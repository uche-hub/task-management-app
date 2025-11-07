import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:task_management_app/features/data/models/tasks_model.dart';
import 'package:task_management_app/features/data/repo/tasks_repo.dart';

// provides the repository instance
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// manages the list of task lists
class ListsNotifier extends StateNotifier<AsyncValue<List<TaskList>>> {
  final TaskRepository _repository;

  ListsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadLists();
  }

  // load all lists from database
  Future<void> loadLists() async {
    state = const AsyncValue.loading();
    try {
      final lists = await _repository.getLists();
      state = AsyncValue.data(lists);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // create a new list
  Future<void> addList(TaskList list) async {
    try {
      await _repository.createList(list);
      await loadLists();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // update list name
  Future<void> updateList(TaskList list) async {
    try {
      await _repository.updateList(list);
      await loadLists();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // delete a list
  Future<void> removeList(String listId) async {
    try {
      await _repository.deleteList(listId);
      await loadLists();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// provider for lists
final listsProvider = StateNotifierProvider<ListsNotifier, AsyncValue<List<TaskList>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return ListsNotifier(repository);
});

// manages tasks for a specific list
class TasksNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;
  final String listId;
  TaskStatus? _currentFilter;
  SortOption _currentSort = SortOption.createdDate;
  List<String> _selectedTagIds = [];

  TasksNotifier(this._repository, this.listId) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  // load tasks and apply current filters/sorting
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

  // filter by status
  Future<void> filterByStatus(TaskStatus? status) async {
    _currentFilter = status;
    await loadTasks();
  }

  // change sort order
  Future<void> sortBy(SortOption option) async {
    _currentSort = option;
    await loadTasks();
  }

  // filter by tags
  Future<void> filterByTags(List<String> tagIds) async {
    _selectedTagIds = tagIds;
    await loadTasks();
  }

  // add a new task
  Future<void> addTask(Task task) async {
    try {
      await _repository.createTask(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // update existing task
  Future<void> updateTask(Task task) async {
    try {
      await _repository.updateTask(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // quick toggle completion
  Future<void> toggleComplete(Task task) async {
    try {
      await _repository.toggleTaskComplete(task);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  // delete a task
  Future<void> removeTask(String taskId) async {
    try {
      await _repository.deleteTask(taskId);
      await loadTasks();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

// provider for tasks in a specific list
final tasksProvider = StateNotifierProvider.family<TasksNotifier, AsyncValue<List<Task>>, String>(
  (ref, listId) {
    final repository = ref.watch(taskRepositoryProvider);
    return TasksNotifier(repository, listId);
  },
);

// manages tags
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

// provider for tags
final tagsProvider = StateNotifierProvider<TagsNotifier, AsyncValue<List<Tag>>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TagsNotifier(repository);
});

// provider for due soon tasks
final dueSoonTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getDueSoonTasks();
});

// provider for search
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Task>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.searchTasks(query);
});