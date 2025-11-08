import 'package:flutter/material.dart';
import '../../../task_core.dart';

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
        return null;
    }
  }

  void _applyFilter(TaskFilter filter) {
    setState(() {
      _currentTaskFilter = filter;
      ref
          .read(tasksProvider(widget.list.id).notifier)
          .filterByStatus(_mapFilterToStatus(filter));
    });
  }

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
            TaskHeaderAppBar(
              listName: widget.list.name,
              currentFilter: _currentTaskFilter,
              isFilterVisible: _isFilterBarVisible,
              onFilterChanged: _applyFilter,
              onSortSelected: (option) => ref
                  .read(tasksProvider(widget.list.id).notifier)
                  .sortBy(option),
              onFilterIconTap: _toggleFilterBar,
            ),
            TagFilterBar(
              listId: widget.list.id,
              selectedTagIds: _selectedTagIds,
              onTagSelected: (selectedTags) {
                setState(
                  () => _selectedTagIds
                    ..clear()
                    ..addAll(selectedTags),
                );
              },
            ),
            Expanded(
              child: tasksAsync.when(
                loading: () => const CustomLoader(),
                error: (error, _) => ErrorStateWidget(
                  error: error,
                  onRetry: () => ref
                      .read(tasksProvider(widget.list.id).notifier)
                      .loadTasks(),
                ),
                data: (tasks) => TaskListView(
                  listId: widget.list.id,
                  tasks: tasks,
                  currentFilter: _currentTaskFilter,
                  onEdit: _editTask,
                  onDelete: _deleteTask,
                ),
              ),
            ),
          ],
        ),
      ),
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
      colors: [cs.primary.withValues(alpha: 0.1), Colors.transparent],
      stops: const [0.0, 0.3],
    ),
  );

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
        builder: (_) => TaskEditorScreen(listId: widget.list.id, task: task),
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
              ref
                  .read(tasksProvider(widget.list.id).notifier)
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
