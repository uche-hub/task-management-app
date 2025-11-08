import '../../../task_core.dart';

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
final tagsProvider = StateNotifierProvider<TagsNotifier, AsyncValue<List<Tag>>>(
  (ref) {
    final repository = ref.watch(taskRepositoryProvider);
    return TagsNotifier(repository);
  },
);
