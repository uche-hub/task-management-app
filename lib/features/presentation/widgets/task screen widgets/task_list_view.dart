import 'package:flutter/material.dart';
import 'package:task_management_app/features/presentation/provider/tasks_notifier.dart';
import '../../../../core/enum/task_filter.dart';
import '../../../../task_core.dart';
import 'task_list_item.dart';

class TaskListView extends ConsumerWidget {
  final String listId;
  final List<Task> tasks;
  final TaskFilter currentFilter;
  final Function(Task) onEdit;
  final Function(Task) onDelete;

  const TaskListView({
    super.key,
    required this.listId,
    required this.tasks,
    required this.currentFilter,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Task> filteredTasks = tasks;

    if (currentFilter == TaskFilter.overdue) {
      filteredTasks = tasks.where((task) {
        if (task.dueDate == null) return false;
        final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        return taskDate.isBefore(todayDate);
      }).toList();
    }

    if (filteredTasks.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveSize.width(32)),
          child: Text(
            'No tasks found for "${currentFilter.name.toUpperCase()}" filter.',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(20),
        ResponsiveSize.height(12),
        ResponsiveSize.width(20),
        ResponsiveSize.height(100),
      ),
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        final task = filteredTasks[index];
        return TaskListItem(
          task: task,
          onTap: () => onEdit(task),
          onToggleComplete: () {
            ref.read(tasksProvider(listId).notifier).toggleComplete(task);
          },
          onDelete: () => onDelete(task),
        );
      },
    );
  }
}
