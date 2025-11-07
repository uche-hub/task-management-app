import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_app/features/data/models/tasks_model.dart';
import 'package:task_management_app/features/presentation/widgets/task_items.dart';

void main() {
  group('TaskItem Widget Tests', () {
    testWidgets('should display task title and description', (tester) async {
      final task = Task(
        id: '1',
        listId: 'list1',
        title: 'Test Task',
        description: 'This is a test description',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskItem(
              task: task,
              onTap: () {},
              onToggleComplete: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // check if title is displayed
      expect(find.text('Test Task'), findsOneWidget);
      
      // check if description is displayed
      expect(find.text('This is a test description'), findsOneWidget);
    });

    testWidgets('should show checkbox for completion', (tester) async {
      final task = Task(
        id: '1',
        listId: 'list1',
        title: 'Test Task',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      bool toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskItem(
              task: task,
              onTap: () {},
              onToggleComplete: () {
                toggled = true;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      // find and tap the checkbox
      final checkbox = find.byType(Checkbox);
      expect(checkbox, findsOneWidget);

      await tester.tap(checkbox);
      await tester.pump();

      expect(toggled, true);
    });

    testWidgets('should display priority badge', (tester) async {
      final task = Task(
        id: '1',
        listId: 'list1',
        title: 'High Priority Task',
        priority: TaskPriority.high,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskItem(
              task: task,
              onTap: () {},
              onToggleComplete: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // check if priority badge shows 'High'
      expect(find.text('High'), findsOneWidget);
    });

    testWidgets('should display tags when present', (tester) async {
      final task = Task(
        id: '1',
        listId: 'list1',
        title: 'Task with tags',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
        tags: [
          Tag(id: '1', name: 'Work', color: Colors.blue.toARGB32()),
          Tag(id: '2', name: 'Urgent', color: Colors.red.toARGB32()),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskItem(
              task: task,
              onTap: () {},
              onToggleComplete: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // check if tags are displayed
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Urgent'), findsOneWidget);
    });

    testWidgets('should show strikethrough for completed tasks', (tester) async {
      final task = Task(
        id: '1',
        listId: 'list1',
        title: 'Completed Task',
        priority: TaskPriority.medium,
        status: TaskStatus.done,
        createdAt: DateTime.now(),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskItem(
              task: task,
              onTap: () {},
              onToggleComplete: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // find the title text
      final titleText = tester.widget<Text>(
        find.text('Completed Task'),
      );

      // check if it has strikethrough decoration
      expect(
        titleText.style?.decoration,
        TextDecoration.lineThrough,
      );
    });

    testWidgets('should call onTap when tapped', (tester) async {
      final task = Task(
        id: '1',
        listId: 'list1',
        title: 'Tappable Task',
        priority: TaskPriority.medium,
        status: TaskStatus.todo,
        createdAt: DateTime.now(),
      );

      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskItem(
              task: task,
              onTap: () {
                tapped = true;
              },
              onToggleComplete: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // tap on the list tile
      await tester.tap(find.byType(ListTile));
      await tester.pump();

      expect(tapped, true);
    });
  });
}