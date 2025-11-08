// sits between the UI and database
// handles any business logic before saving/loading data
import '../../../task_core.dart';

class TaskRepository {
  final TaskDao _dao;

  TaskRepository({TaskDao? dao}) : _dao = dao ?? TaskDao();

  // list operations
  Future<List<TaskList>> getLists() async {
    return await _dao.getAllLists();
  }

  // <--- ADDED: Get task counts with combined data --->
  Future<Map<String, ListTaskStats>> getListsWithTaskStats() async {
    final lists = await _dao.getAllLists();
    final listIds = lists.map((l) => l.id).toList();
    final counts = await _dao.getTaskCountsForLists(listIds);

    final Map<String, ListTaskStats> result = {};
    for (final list in lists) {
      final encodedCount = counts[list.id] ?? 0;
      final done = encodedCount % 1000;
      final total = encodedCount ~/ 1000;

      result[list.id] = ListTaskStats(
        list: list,
        totalTasks: total,
        doneTasks: done,
      );
    }
    return result;
  }

  Future<void> createList(TaskList list) async {
    // make sure name isn't empty
    if (list.name.trim().isEmpty) {
      throw Exception('List name cannot be empty');
    }
    await _dao.insertList(list);
  }

  Future<void> updateList(TaskList list) async {
    if (list.name.trim().isEmpty) {
      throw Exception('List name cannot be empty');
    }
    await _dao.updateList(list);
  }

  Future<void> deleteList(String listId) async {
    await _dao.deleteList(listId);
  }

  // task operations
  Future<List<Task>> getTasksForList(String listId) async {
    return await _dao.getTasksByList(listId);
  }

  Future<List<Task>> getTasksByStatus(String listId, TaskStatus status) async {
    return await _dao.getTasksByStatus(listId, status);
  }

  Future<List<Task>> getDueSoonTasks() async {
    return await _dao.getDueSoonTasks();
  }

  Future<List<Task>> searchTasks(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _dao.searchTasks(query.trim());
  }

  Future<void> createTask(Task task) async {
    // validate title
    if (task.title.trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }

    // make sure due date isn't in the past
    if (task.dueDate != null) {
      final now = DateTime.now();
      final taskDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      final today = DateTime(now.year, now.month, now.day);

      if (taskDate.isBefore(today)) {
        throw Exception('Due date cannot be in the past');
      }
    }

    await _dao.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    if (task.title.trim().isEmpty) {
      throw Exception('Task title cannot be empty');
    }

    if (task.dueDate != null) {
      final now = DateTime.now();
      final taskDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      final today = DateTime(now.year, now.month, now.day);

      if (taskDate.isBefore(today)) {
        throw Exception('Due date cannot be in the past');
      }
    }

    await _dao.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    await _dao.deleteTask(taskId);
  }

  // quick toggle task completion
  Future<void> toggleTaskComplete(Task task) async {
    final newStatus = task.status == TaskStatus.done
        ? TaskStatus.todo
        : TaskStatus.done;

    final updatedTask = task.copyWith(status: newStatus);
    await _dao.updateTask(updatedTask);
  }

  // tag operations
  Future<List<Tag>> getAllTags() async {
    return await _dao.getAllTags();
  }

  Future<void> createTag(Tag tag) async {
    if (tag.name.trim().isEmpty) {
      throw Exception('Tag name cannot be empty');
    }
    await _dao.insertTag(tag);
  }

  Future<void> deleteTag(String tagId) async {
    await _dao.deleteTag(tagId);
  }

  // sort tasks by different criteria
  List<Task> sortTasks(List<Task> tasks, SortOption option) {
    final sortedTasks = List<Task>.from(tasks);

    switch (option) {
      case SortOption.dueDate:
        sortedTasks.sort((a, b) {
          // tasks without due date go to the end
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;

      case SortOption.priority:
        sortedTasks.sort((a, b) {
          // higher priority first
          return b.priority.value.compareTo(a.priority.value);
        });
        break;

      case SortOption.createdDate:
        sortedTasks.sort((a, b) {
          return b.createdAt.compareTo(a.createdAt);
        });
        break;
    }

    return sortedTasks;
  }

  // filter tasks by multiple tags
  List<Task> filterByTags(List<Task> tasks, List<String> tagIds) {
    if (tagIds.isEmpty) return tasks;

    return tasks.where((task) {
      final taskTagIds = task.tags.map((t) => t.id).toSet();
      // task must have all selected tags
      return tagIds.every((id) => taskTagIds.contains(id));
    }).toList();
  }
}

class ListTaskStats {
  final TaskList list;
  final int totalTasks;
  final int doneTasks;

  ListTaskStats({
    required this.list,
    required this.totalTasks,
    required this.doneTasks,
  });

  double get progress => totalTasks == 0 ? 0.0 : doneTasks / totalTasks;
}

enum SortOption { dueDate, priority, createdDate }
