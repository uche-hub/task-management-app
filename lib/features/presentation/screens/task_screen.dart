import 'package:flutter/material.dart';

import '../../../task_core.dart';

// shows all tasks in a list
class TasksScreen extends ConsumerStatefulWidget {
  final TaskList list;

  const TasksScreen({super.key, required this.list});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  TaskStatus? _currentFilter;
  final List<String> _selectedTagIds = [];

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider(widget.list.id));
    final tagsAsync = ref.watch(tagsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.list.name),
        actions: [
          // filter menu
          PopupMenuButton(
            icon: Icon(
              _currentFilter != null ? Icons.filter_alt : Icons.filter_alt_outlined,
            ),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('All tasks'),
              ),
              const PopupMenuItem(
                value: TaskStatus.todo,
                child: Text('To Do'),
              ),
              const PopupMenuItem(
                value: TaskStatus.inProgress,
                child: Text('In Progress'),
              ),
              const PopupMenuItem(
                value: TaskStatus.done,
                child: Text('Done'),
              ),
            ],
            onSelected: (status) {
              setState(() => _currentFilter = status);
              ref.read(tasksProvider(widget.list.id).notifier)
                  .filterByStatus(status);
            },
          ),
          
          // sort menu
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortOption.createdDate,
                child: Text('Date Created'),
              ),
              const PopupMenuItem(
                value: SortOption.dueDate,
                child: Text('Due Date'),
              ),
              const PopupMenuItem(
                value: SortOption.priority,
                child: Text('Priority'),
              ),
            ],
            onSelected: (option) {
              ref.read(tasksProvider(widget.list.id).notifier)
                  .sortBy(option);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // tag filter chips
          tagsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (tags) {
              if (tags.isEmpty) return const SizedBox.shrink();
              
              return Container(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 8,
                  children: tags.map((tag) {
                    final isSelected = _selectedTagIds.contains(tag.id);
                    return FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTagIds.add(tag.id);
                          } else {
                            _selectedTagIds.remove(tag.id);
                          }
                        });
                        ref.read(tasksProvider(widget.list.id).notifier)
                            .filterByTags(_selectedTagIds);
                      },
                      avatar: CircleAvatar(
                        backgroundColor: Color(tag.color),
                        radius: 8,
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          
          // tasks list
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Could not load tasks'),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(tasksProvider(widget.list.id).notifier).loadTasks(),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),
              
              data: (tasks) {
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _currentFilter != null 
                              ? Icons.filter_list_off 
                              : Icons.task_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentFilter != null 
                              ? 'No tasks match your filter'
                              : 'No tasks yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentFilter != null
                              ? 'Try changing your filter or create a new task'
                              : 'Tap the + button to add your first task',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskItem(
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createTask,
        child: const Icon(Icons.add),
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