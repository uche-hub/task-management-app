import 'package:flutter/material.dart';
import 'package:task_management_app/core/enum/task_filter.dart';
import 'package:task_management_app/core/enum/task_status.dart';
import 'package:task_management_app/features/data/models/task_list.dart';
import 'package:task_management_app/features/data/models/task_tag.dart';
import '../../../task_core.dart';
import '../widgets/task screen widgets/task_header_appbar.dart'; 
import '../widgets/task screen widgets/task_list_item.dart';

// shows all tasks in a list
class TasksScreen extends ConsumerStatefulWidget {
  final TaskList list;

  const TasksScreen({super.key, required this.list});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskFilter _currentTaskFilter = TaskFilter.all;
  final List<String> _selectedTagIds = [];
  bool _isFilterBarVisible = false;

  TaskStatus? _mapFilterToStatus(TaskFilter filter) {
    switch (filter) {
      case TaskFilter.todo:
        return TaskStatus.todo;
      case TaskFilter.inProgress:
        return TaskStatus.inProgress;
      case TaskFilter.done:
        return TaskStatus.done;
      case TaskFilter.all:
      case TaskFilter.overdue: 
      return null; // Load all tasks for 'All' and 'Overdue'
    }
  }
  
  // Applies the filter to the TasksNotifier (Reverted to original logic)
  void _applyFilter(TaskFilter filter) {
    setState(() {
      _currentTaskFilter = filter;
      ref.read(tasksProvider(widget.list.id).notifier)
          .filterByStatus(_mapFilterToStatus(filter));
    });
  }
  
  // Toggles the visibility of the filter bar
  void _toggleFilterBar() {
    setState(() {
      _isFilterBarVisible = !_isFilterBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider(widget.list.id));
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: _bgGradient(cs),
        child: Column(
          children: [
            // Custom Header
            TaskHeaderAppBar(
              listName: widget.list.name,
              currentFilter: _currentTaskFilter,
              isFilterVisible: _isFilterBarVisible,
              onFilterChanged: _applyFilter,
              onSortSelected: (option) => ref.read(tasksProvider(widget.list.id).notifier).sortBy(option),
              onFilterIconTap: _toggleFilterBar,
            ),

            // Tag Filter Chips 
            _buildTagFilter(),
            
            Expanded(
              child: tasksAsync.when(
                loading: () => const CustomLoader(),
                error: (error, stack) => _buildErrorState(error),
                data: (tasks) => _buildTaskList(tasks),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  BoxDecoration _bgGradient(ColorScheme cs) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        cs.primary.withValues(alpha: 0.1),
        Colors.transparent,
      ],
      stops: const [0.0, 0.3],
    ),
  );

  Widget _buildTagFilter() {
    final tagsAsync = ref.watch(tagsProvider);
    return tagsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: EdgeInsets.fromLTRB(
            ResponsiveSize.width(20), 
            ResponsiveSize.height(8), 
            ResponsiveSize.width(20), 
            ResponsiveSize.height(8),
          ),
          child: Wrap(
            spacing: ResponsiveSize.width(8),
            runSpacing: ResponsiveSize.height(4),
            children: tags.map((tag) {
              final isSelected = _selectedTagIds.contains(tag.id);
              return _TagChip(
                tag: tag, 
                isSelected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTagIds.add(tag.id);
                    } else {
                      _selectedTagIds.remove(tag.id);
                    }
                  });
                  ref.read(tasksProvider(widget.list.id).notifier).filterByTags(_selectedTagIds);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }


  Widget _buildTaskList(List<Task> tasks) {
    // Apply overdue filter locally if selected (Reverted to original logic)
    List<Task> filteredTasks = tasks;
    if (_currentTaskFilter == TaskFilter.overdue) {
      filteredTasks = tasks.where((task) {
        if (task.dueDate == null) return false;
        // Check if the due date is before today (only check date part)
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
            'No tasks found for "${_currentTaskFilter.name.toUpperCase()}" filter.',
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
          onTap: () => _editTask(task),
          onToggleComplete: () {
            ref.read(tasksProvider(widget.list.id).notifier)
                .toggleComplete(task);
          },
          onDelete: () => _deleteTask(task),
        );
      },
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: ErrorState(
        error: error,
        onRetry: () => ref.read(tasksProvider(widget.list.id).notifier).loadTasks(),
      ),
    );
  }

  void _createTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(listId: widget.list.id),
      ),
    );
    if (result == true) {
      ref.read(tasksProvider(widget.list.id).notifier).loadTasks();
    }
  }

  void _editTask(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(
          listId: widget.list.id,
          task: task,
        ),
      ),
    );

    if (result == true) {
      ref.read(tasksProvider(widget.list.id).notifier).loadTasks();
    }
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('Delete "${task.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(tasksProvider(widget.list.id).notifier)
                  .removeTask(task.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}


// New dedicated widget for the redesigned tag chip
class _TagChip extends StatelessWidget {
  final Tag tag;
  final bool isSelected;
  final Function(bool) onSelected;

  const _TagChip({required this.tag, required this.isSelected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final chipColor = Color(tag.color);
    return ActionChip(
      label: Text(tag.name),
      onPressed: () => onSelected(!isSelected),
      avatar: CircleAvatar(
        backgroundColor: isSelected ? Colors.white : chipColor,
        radius: ResponsiveSize.radius(6),
        child: isSelected ? Icon(Icons.check, size: ResponsiveSize.icon(8), color: chipColor) : null,
      ),
      labelStyle: TextStyle(
        fontSize: ResponsiveSize.fontSize(12),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : chipColor.withValues(alpha: 0.8),
      ),
      backgroundColor: isSelected ? chipColor : chipColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(10)),
        side: BorderSide(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(8),
        vertical: ResponsiveSize.height(4),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}