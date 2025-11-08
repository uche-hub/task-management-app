// lib/features/presentation/screens/search_screen.dart

import 'package:flutter/material.dart';
import 'package:task_management_app/features/presentation/widgets/search%20widgets/search_no_results.dart';
import '../../../task_core.dart';
import '../widgets/search widgets/search_empty.dart';
import '../widgets/search widgets/search_error.dart';
import '../widgets/search widgets/search_loading.dart';
import '../widgets/search widgets/search_result_header.dart';
import '../widgets/search widgets/search_result_item.dart';

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
    // Initialize controller with current query from provider
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
    // Update the provider instantly on change
    ref.read(searchQueryProvider.notifier).state = _searchController.text;
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(cs, query.isNotEmpty), // Custom AppBar for iOS-style header
      body: Container(
        decoration: _backgroundGradient(cs),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + ResponsiveSize.height(60)), // Space for AppBar
            
            // Search Input Field (Moved from AppBar to body area for simpler control)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(20)),
              child: _buildSearchInputField(cs, query),
            ),
            
            SizedBox(height: ResponsiveSize.height(16)),
            
            Expanded(
              child: results.when(
                loading: () => const SearchLoading(),
                error: (e, _) => SearchError(error: e),
                data: (tasks) {
                  if (query.isEmpty) return const SearchEmpty();
                  if (tasks.isEmpty) return const SearchNoResults();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchResultHeader(count: tasks.length),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                            ResponsiveSize.width(20),
                            ResponsiveSize.height(12),
                            ResponsiveSize.width(20),
                            ResponsiveSize.height(100),
                          ),
                          separatorBuilder: (_, __) => SizedBox(height: ResponsiveSize.height(14)),
                          itemCount: tasks.length,
                          itemBuilder: (_, i) {
                            final task = tasks[i];
                            return SearchResultItem(
                              task: task,
                              onTap: () => _editTask(task),
                              onToggle: () => _toggleTask(task),
                              onDelete: () => _showDelete(task),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- AppBar adapted for clean look ---
  AppBar _buildAppBar(ColorScheme cs, bool hasQuery) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'Global Search',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveSize.fontSize(20),
          color: cs.onSurface,
        ),
      ),
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: cs.onSurface),
        onPressed: () => AppRouter.router.pop(),
      ),
    );
  }

  // --- New Search Input Field Widget ---
  Widget _buildSearchInputField(ColorScheme cs, String query) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(16)),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        style: TextStyle(fontSize: ResponsiveSize.fontSize(16)),
        decoration: InputDecoration(
          hintText: 'Search tasks by title or tags',
          hintStyle: TextStyle(
            color: cs.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: ResponsiveSize.fontSize(16),
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search_rounded,
            size: ResponsiveSize.icon(22),
            color: cs.onSurfaceVariant,
          ),
          suffixIcon: query.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear_rounded, color: cs.onSurfaceVariant),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged();
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: ResponsiveSize.height(12),
          ),
        ),
      ),
    );
  }

  BoxDecoration _backgroundGradient(ColorScheme cs) {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          cs.primary.withValues(alpha: 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4],
      ),
    );
  }

  void _editTask(Task task) async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskEditorScreen(listId: task.listId, task: task),
      ),
    );
    // Invalidate results if edited
    if (updated == true) ref.invalidate(searchResultsProvider);
  }
  
  void _toggleTask(Task task) {
    ref.read(tasksProvider(task.listId).notifier).toggleComplete(task);
    // Also invalidate search results to reflect the status change
    ref.invalidate(searchResultsProvider);
  }

  void _showDelete(Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: ResponsiveSize.icon(28)),
            SizedBox(width: ResponsiveSize.width(12)),
            const Text('Delete Task?', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Delete "${task.title}"?\nThis cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(tasksProvider(task.listId).notifier).removeTask(task.id);
              Navigator.pop(context);
              // Invalidate search results and the list that contained the task
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