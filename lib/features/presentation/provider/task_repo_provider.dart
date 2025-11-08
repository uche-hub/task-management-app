import '../../../task_core.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Manages the list of task lists with their stats
class ListsStatsNotifier
    extends StateNotifier<AsyncValue<List<ListTaskStats>>> {
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

// Provider for lists
final listsProvider =
    StateNotifierProvider<ListsStatsNotifier, AsyncValue<List<ListTaskStats>>>((
      ref,
    ) {
      final repository = ref.watch(taskRepositoryProvider);
      return ListsStatsNotifier(repository);
    });

final dueSoonTasksProvider = FutureProvider<List<Task>>((ref) async {
  final repository = ref.watch(taskRepositoryProvider);
  return await repository.getDueSoonTasks();
});
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Task>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];

  final repository = ref.watch(taskRepositoryProvider);
  return await repository.searchTasks(query);
});
