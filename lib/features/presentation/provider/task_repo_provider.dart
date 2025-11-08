// lib/features/presentation/provider/task_repo_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:task_management_app/features/data/models/tasks_model.dart';
import 'package:task_management_app/features/data/repo/tasks_repo.dart';

// provides the repository instance
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Manages the list of task lists with their stats (for ListsScreen display)
class ListsStatsNotifier extends StateNotifier<AsyncValue<List<ListTaskStats>>> { 
  final TaskRepository _repository;

  ListsStatsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadLists();
  }

  // Load all lists from database and compute stats
  Future<void> loadLists() async {
    state = const AsyncValue.loading();
    try {
      final listStatsMap = await _repository.getListsWithTaskStats(); 
      final lists = listStatsMap.values.toList()
        ..sort((a, b) => b.list.createdAt.compareTo(a.list.createdAt)); 

      state = AsyncValue.data(lists);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // CRUD operations which trigger a full list reload
  Future<void> addList(TaskList list) async {
    try {
      await _repository.createList(list);
      await loadLists();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateList(TaskList list) async {
    try {
      await _repository.updateList(list);
      await loadLists();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeList(String listId) async {
    try {
      await _repository.deleteList(listId);
      await loadLists();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Provider for lists (now with stats)
final listsProvider = StateNotifierProvider<ListsStatsNotifier, AsyncValue<List<ListTaskStats>>>((ref) { 
  final repository = ref.watch(taskRepositoryProvider);
  return ListsStatsNotifier(repository);
});

// -----------------------------------------------------------------------------

// Manages tasks for a specific list (for TasksScreen display)
class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;
  final String listId;
  TaskStatus? _currentFilter;
  SortOption _currentSort = SortOption.createdDate;
  List<String> _selectedTagIds = [];
  final Ref _ref; // Used for cross-provider invalidation

  TasksNotifier(this._repository, this.listId, this._ref) : super(const AsyncValue.loading()) { 
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
final tasksProvider = StateNotifierProvider.family<TasksNotifier, AsyncValue<List<Task>>, String>(
  (ref, listId) {
    final repository = ref.watch(taskRepositoryProvider);
    return TasksNotifier(repository, listId, ref); 
  },
);

// -----------------------------------------------------------------------------

// Manages tags
class TagsNotifier extends StateNotifier<AsyncValue<List<Tag>>> {
  final TaskRepository _repository;

  TagsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadTags();
  }

  Future<void> loadTags() async {
    state = const AsyncValue.loading();
    try {
      final tags = await _repository.getAllTags();
      state = AsyncValue.data(tags);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTag(Tag tag) async {
    try {
      await _repository.createTag(tag);
      await loadTags();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> removeTag(String tagId) async {
    try {
      await _repository.deleteTag(tagId);
      await loadTags();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// Provider for tags
final tagsProvider = StateNotifierProvider<TagsNotifier, AsyncValue<List<Tag>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TagsNotifier(repository);
});

// Provider for due soon tasks
final dueSoonTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getDueSoonTasks();
});

// Provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider for search results
final searchResultsProvider = FutureProvider<List<Task>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.searchTasks(query);
});