import 'package:sqflite/sqflite.dart';
import 'package:task_management_app/core/enum/task_status.dart';
import 'package:task_management_app/features/data/models/task_list.dart';
import 'package:task_management_app/features/data/models/task_tag.dart';

import '../../../task_core.dart';

class TaskDao {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // get all lists
  Future<List<TaskList>> getAllLists() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'lists',
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => TaskList.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load lists: $e');
    }
  }

  Future<Map<String, int>> getTaskCountsForLists(List<String> listIds) async {
    if (listIds.isEmpty) return {};
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT list_id, status, COUNT(id) as count
        FROM tasks
        WHERE list_id IN (${listIds.map((_) => '?').join(',')})
        GROUP BY list_id, status
      ''', listIds);

      final Map<String, int> totalTasks = {};
      final Map<String, int> doneTasks = {};

      for (var map in maps) {
        final listId = map['list_id'] as String;
        final count = map['count'] as int;
        final status = map['status'] as String;

        totalTasks.update(
          listId,
          (value) => value + count,
          ifAbsent: () => count,
        );
        if (status == TaskStatus.done.value) {
          doneTasks.update(
            listId,
            (value) => value + count,
            ifAbsent: () => count,
          );
        }
      }

      final Map<String, int> results = {};
      for (final listId in listIds) {
        final total = totalTasks[listId] ?? 0;
        final done = doneTasks[listId] ?? 0;
        results[listId] = total * 1000 + done;
      }
      return results;
    } catch (e) {
      throw Exception('Failed to load task counts: $e');
    }
  }

  // create a new list
  Future<void> insertList(TaskList list) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'lists',
        list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to create list: $e');
    }
  }

  // update an existing list
  Future<void> updateList(TaskList list) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'lists',
        list.toMap(),
        where: 'id = ?',
        whereArgs: [list.id],
      );
    } catch (e) {
      throw Exception('Failed to update list: $e');
    }
  }

  // delete a list (and all its tasks)
  Future<void> deleteList(String listId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('lists', where: 'id = ?', whereArgs: [listId]);
    } catch (e) {
      throw Exception('Failed to delete list: $e');
    }
  }

  // get all tasks for a specific list
  Future<List<Task>> getTasksByList(String listId) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'list_id = ?',
        whereArgs: [listId],
        orderBy: 'created_at DESC',
      );

      // load tags for each task
      List<Task> tasks = [];
      for (var map in maps) {
        final tags = await _getTaskTags(map['id'] as String);
        tasks.add(Task.fromMap(map, tags: tags));
      }
      return tasks;
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  // get tasks filtered by status
  Future<List<Task>> getTasksByStatus(String listId, TaskStatus status) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where: 'list_id = ? AND status = ?',
        whereArgs: [listId, status.value],
        orderBy: 'created_at DESC',
      );

      List<Task> tasks = [];
      for (var map in maps) {
        final tags = await _getTaskTags(map['id'] as String);
        tasks.add(Task.fromMap(map, tags: tags));
      }
      return tasks;
    } catch (e) {
      throw Exception('Failed to filter tasks: $e');
    }
  }

  // get tasks that are due soon
  Future<List<Task>> getDueSoonTasks() async {
    try {
      final db = await _dbHelper.database;
      final now = DateTime.now().millisecondsSinceEpoch;
      final later = DateTime.now()
          .add(Duration(hours: 48))
          .millisecondsSinceEpoch;

      final List<Map<String, dynamic>> maps = await db.query(
        'tasks',
        where:
            'due_date IS NOT NULL AND due_date BETWEEN ? AND ? AND status != ?',
        whereArgs: [now, later, TaskStatus.done.value],
        orderBy: 'due_date ASC',
      );

      List<Task> tasks = [];
      for (var map in maps) {
        final tags = await _getTaskTags(map['id'] as String);
        tasks.add(Task.fromMap(map, tags: tags));
      }
      return tasks;
    } catch (e) {
      throw Exception('Failed to load due soon tasks: $e');
    }
  }

  // search tasks by title or tags
  Future<List<Task>> searchTasks(String query) async {
    try {
      final db = await _dbHelper.database;

      // search in task titles
      final titleMatches = await db.query(
        'tasks',
        where: 'title LIKE ?',
        whereArgs: ['%$query%'],
      );

      // search in tags
      final tagMatches = await db.rawQuery(
        '''
        SELECT DISTINCT t.* FROM tasks t
        INNER JOIN task_tags tt ON t.id = tt.task_id
        INNER JOIN tags tg ON tt.tag_id = tg.id
        WHERE tg.name LIKE ?
      ''',
        ['%$query%'],
      );

      // combine results without duplicates
      final Map<String, Map<String, dynamic>> uniqueTasks = {};
      for (var map in [...titleMatches, ...tagMatches]) {
        uniqueTasks[map['id'] as String] = map;
      }

      List<Task> tasks = [];
      for (var map in uniqueTasks.values) {
        final tags = await _getTaskTags(map['id'] as String);
        tasks.add(Task.fromMap(map, tags: tags));
      }
      return tasks;
    } catch (e) {
      throw Exception('Failed to search tasks: $e');
    }
  }

  // create a new task
  Future<void> insertTask(Task task) async {
    try {
      final db = await _dbHelper.database;
      await db.transaction((txn) async {
        // insert the task
        await txn.insert(
          'tasks',
          task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        // link tags to the task
        for (var tag in task.tags) {
          await txn.insert('task_tags', {
            'task_id': task.id,
            'tag_id': tag.id,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // update an existing task
  Future<void> updateTask(Task task) async {
    try {
      final db = await _dbHelper.database;
      await db.transaction((txn) async {
        // update the task
        await txn.update(
          'tasks',
          task.toMap(),
          where: 'id = ?',
          whereArgs: [task.id],
        );

        // remove old tag
        await txn.delete(
          'task_tags',
          where: 'task_id = ?',
          whereArgs: [task.id],
        );

        // add new tag links
        for (var tag in task.tags) {
          await txn.insert('task_tags', {
            'task_id': task.id,
            'tag_id': tag.id,
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      });
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('tasks', where: 'id = ?', whereArgs: [taskId]);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // get tags for a specific task
  Future<List<Tag>> _getTaskTags(String taskId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT t.* FROM tags t
      INNER JOIN task_tags tt ON t.id = tt.tag_id
      WHERE tt.task_id = ?
    ''',
      [taskId],
    );
    return maps.map((map) => Tag.fromMap(map)).toList();
  }

  // get all available tags
  Future<List<Tag>> getAllTags() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('tags');
      return maps.map((map) => Tag.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to load tags: $e');
    }
  }

  // create a new tag
  Future<void> insertTag(Tag tag) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'tags',
        tag.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Failed to create tag: $e');
    }
  }

  // delete a tag
  Future<void> deleteTag(String tagId) async {
    try {
      final db = await _dbHelper.database;
      await db.delete('tags', where: 'id = ?', whereArgs: [tagId]);
    } catch (e) {
      throw Exception('Failed to delete tag: $e');
    }
  }
}
