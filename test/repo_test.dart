import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/core/enum/sort_option.dart';
import 'package:task_management_app/core/enum/task_priority.dart';
import 'package:task_management_app/core/enum/task_status.dart';
import 'package:task_management_app/features/data/models/task_list.dart';
import 'package:task_management_app/task_core.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // setup for testing with sqflite
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('TaskRepository Tests', () {
    late TaskRepository repository;
    late TaskDao dao;
    final uuid = const Uuid();

    setUp(() async {
      // clean database before each test
      await DatabaseHelper.instance.deleteDatabase();
      dao = TaskDao();
      repository = TaskRepository(dao: dao);
    });

    tearDown(() async {
      await DatabaseHelper.instance.close();
    });

    test('should create and retrieve a task list', () async {
      // create a list
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );

      await repository.createList(list);

      // get it back
      final lists = await repository.getLists();

      expect(lists.length, 1);
      expect(lists.first.name, 'Test List');
    });

    test('should create and retrieve a task', () async {
      // first create a list
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );
      await repository.createList(list);

      // then create a task
      final task = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Test Task',
        description: 'This is a test',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      await repository.createTask(task);

      // retrieve it
      final tasks = await repository.getTasksForList(list.id);

      expect(tasks.length, 1);
      expect(tasks.first.title, 'Test Task');
      expect(tasks.first.priority, TaskPriority.high);
    });

    test('should filter tasks by status', () async {
      // create a list
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );
      await repository.createList(list);

      // create tasks with different statuses
      final task1 = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Todo Task',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      final task2 = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Done Task',
        priority: TaskPriority.medium,
        status: TaskStatus.done,
        createdAt: DateTime.now(),
      );

      await repository.createTask(task1);
      await repository.createTask(task2);

      // filter by status
      final todoTasks = await repository.getTasksByStatus(list.id, TaskStatus.todo);
      final doneTasks = await repository.getTasksByStatus(list.id, TaskStatus.done);

      expect(todoTasks.length, 1);
      expect(todoTasks.first.title, 'Todo Task');
      expect(doneTasks.length, 1);
      expect(doneTasks.first.title, 'Done Task');
    });

    test('should sort tasks correctly', () async {
      final now = DateTime.now();
      
      final tasks = [
        Task(
          id: '1',
          listId: 'list1',
          title: 'Low Priority',
          priority: TaskPriority.low,
          status: TaskStatus.todo,
          createdAt: now,
        ),
        Task(
          id: '2',
          listId: 'list1',
          title: 'High Priority',
          priority: TaskPriority.high,
          status: TaskStatus.todo,
          createdAt: now,
        ),
        Task(
          id: '3',
          listId: 'list1',
          title: 'Medium Priority',
          priority: TaskPriority.medium,
          status: TaskStatus.todo,
          createdAt: now,
        ),
      ];

      // sort by priority
      final sorted = repository.sortTasks(tasks, SortOption.priority);

      expect(sorted[0].priority, TaskPriority.high);
      expect(sorted[1].priority, TaskPriority.medium);
      expect(sorted[2].priority, TaskPriority.low);
    });

    test('should validate task title is not empty', () async {
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );
      await repository.createList(list);

      final task = Task(
        id: uuid.v4(),
        listId: list.id,
        title: '',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      // should throw an error
      expect(
        () => repository.createTask(task),
        throwsA(isA<Exception>()),
      );
    });

    test('should validate due date is not in the past', () async {
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );
      await repository.createList(list);

      final task = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Test Task',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      // should throw an error
      expect(
        () => repository.createTask(task),
        throwsA(isA<Exception>()),
      );
    });

    test('should toggle task completion', () async {
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );
      await repository.createList(list);

      final task = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Test Task',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      await repository.createTask(task);

      // toggle to done
      await repository.toggleTaskComplete(task);

      final tasks = await repository.getTasksForList(list.id);
      expect(tasks.first.status, TaskStatus.done);

      // toggle back to todo
      await repository.toggleTaskComplete(tasks.first);

      final updatedTasks = await repository.getTasksForList(list.id);
      expect(updatedTasks.first.status, TaskStatus.todo);
    });

    test('should search tasks by title', () async {
      final list = TaskList(
        id: uuid.v4(),
        name: 'Test List',
        createdAt: DateTime.now(),
      );
      await repository.createList(list);

      final task1 = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Buy groceries',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      final task2 = Task(
        id: uuid.v4(),
        listId: list.id,
        title: 'Call dentist',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      await repository.createTask(task1);
      await repository.createTask(task2);

      // search for 'groceries'
      final results = await repository.searchTasks('groceries');

      expect(results.length, 1);
      expect(results.first.title, 'Buy groceries');
    });
  });
}