import 'package:flutter/material.dart';
import 'package:task_management_app/features/presentation/provider/tasks_notifier.dart';
import 'package:task_management_app/features/presentation/widgets/search%20widgets/search_app_bar.dart';
import 'package:task_management_app/features/presentation/widgets/search%20widgets/search_result_list.dart';
import '../../../task_core.dart';
import '../widgets/search widgets/search_empty.dart';
import '../widgets/search widgets/search_error.dart';
import '../widgets/search widgets/search_loading.dart';
import '../widgets/search widgets/search_no_results.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final query = ref.read(searchQueryProvider);
    _searchController.text = query;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    ref.read(searchQueryProvider.notifier).state = _searchController.text;
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: SearchAppBar(),
      body: Container(
        decoration: _backgroundGradient(cs),
        child: Column(
          children: [
            SizedBox(
              height:
                  MediaQuery.of(context).padding.top +
                  ResponsiveSize.height(60),
            ),

            SizedBox(height: ResponsiveSize.height(16)),

            Expanded(
              child: results.when(
                loading: () => const SearchLoading(),
                error: (e, _) => SearchError(error: e),
                data: (tasks) {
                  if (query.isEmpty) return const SearchEmpty();
                  if (tasks.isEmpty) return const SearchNoResults();

                  return SearchResultList(
                    tasks: tasks,
                    onTap: _editTask,
                    onToggle: _toggleTask,
                    onDelete: _showDelete,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _backgroundGradient(ColorScheme cs) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [cs.primary.withValues(alpha: 0.08), Colors.transparent],
      stops: const [0.0, 0.4],
    ),
  );

  void _editTask(Task task) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(listId: task.listId, task: task),
      ),
    );
    if (updated == true) ref.invalidate(searchResultsProvider);
  }

  void _toggleTask(Task task) {
    ref.read(tasksProvider(task.listId).notifier).toggleComplete(task);
    ref.invalidate(searchResultsProvider);
  }

  void _showDelete(Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.red[600],
              size: ResponsiveSize.icon(28),
            ),
            SizedBox(width: ResponsiveSize.width(12)),
            const Text(
              'Delete Task?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text('Delete "${task.title}"?\nThis cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(tasksProvider(task.listId).notifier).removeTask(task.id);
              Navigator.pop(context);
              ref.invalidate(searchResultsProvider);
              ref.invalidate(listsProvider);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
