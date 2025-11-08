import '../../../task_core.dart';

class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;
  final String listId;
  TaskStatus? _currentFilter;
  SortOption _currentSort = SortOption.createdDate;
  List<String> _selectedTagIds = [];
  final Ref _ref; // cross-provider invalidation

  TasksNotifier(this._repository, this.listId, this._ref)
    : super(const AsyncValue.loading()) {
    loadTasks();
  }

  // Helper to force synchronization of the parent list statistics
  void _invalidateParentList() {
    _ref.invalidate(listsProvider);
  }

  // Load tasks and apply current filters/sorting
  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    try {
      List<Task> tasks;

      if (_currentFilter != null) {
        tasks = await _repository.getTasksByStatus(listId, _currentFilter!);
      } else {
        tasks = await _repository.getTasksForList(listId);
      }

      // apply tag filter if any
      if (_selectedTagIds.isNotEmpty) {
        tasks = _repository.filterByTags(tasks, _selectedTagIds);
      }

      // apply sorting
      tasks = _repository.sortTasks(tasks, _currentSort);

      state = AsyncValue.data(tasks);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // Filtering methods
  Future<void> filterByStatus(TaskStatus? status) async {
    _currentFilter = status;
    await loadTasks();
  }

  Future<void> sortBy(SortOption option) async {
    _currentSort = option;
    await loadTasks();
  }

  Future<void> filterByTags(List<String> tagIds) async {
    _selectedTagIds = tagIds;
    await loadTasks();
  }

  // Task mutation methods (with cross-provider invalidation)

  Future<void> addTask(Task task) async {
    try {
      await _repository.createTask(task);
      await loadTasks();
      _invalidateParentList(); // 💡 FIX: Update task counts in ListsScreen
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _repository.updateTask(task);
      await loadTasks();
      _invalidateParentList();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> toggleComplete(Task task) async {
    try {
      await _repository.toggleTaskComplete(task);
      await loadTasks();
      _invalidateParentList();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
      await loadTasks();
      _invalidateParentList();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Provider for tasks in a specific list, providing access to Ref
final tasksProvider =
    StateNotifierProvider.family<TasksNotifier, AsyncValue<List<Task>>, String>(
      (ref, listId) {
        final repository = ref.watch(taskRepositoryProvider);
        return TasksNotifier(repository, listId, ref);
      },
    );
