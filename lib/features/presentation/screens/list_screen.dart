// lib/features/presentation/screens/list_screen.dart

import 'package:flutter/material.dart';
import 'package:task_management_app/features/data/models/task_list.dart';
import 'package:task_management_app/features/data/repo/list_task_stats.dart';
import '../../../task_core.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen>
    with TickerProviderStateMixin {
  final _uuid = const Uuid();
  late final AnimationController _fabCtrl;

  @override
  void initState() {
    super.initState();
    _fabCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _fabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize.init(context);
    final cs = Theme.of(context).colorScheme;
    final listsAsync = ref.watch(listsProvider); 

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(cs),
      body: Container(
        decoration: _bgGradient(cs),
        child: listsAsync.when(
          loading: () => const CustomLoader(), 
          error: (e, _) => ErrorState(error: e, onRetry: _retry),
          data: (lists) =>
              lists.isEmpty ? const EmptyState() : _buildRefreshableList(lists), // <--- CHANGED
        ),
      ),
      floatingActionButton: ListsFAB(
        controller: _fabCtrl,
        onPressed: _showCreate,
      ),
    );
  }

  // --- NEW: Refreshable List Wrapper ---
  Widget _buildRefreshableList(List<ListTaskStats> lists) {
    // The RefreshIndicator calls the _retry function to reload data
    return RefreshIndicator(
      onRefresh: _retry,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: _listView(lists),
    );
  }
  
  // --- Existing AppBar & Background methods ---

  PreferredSizeWidget _appBar(ColorScheme cs) {
    return AppBar(
      automaticallyImplyLeading: false, 
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding( 
        padding: EdgeInsets.only(left: ResponsiveSize.width(4)),
        child: Text(
          'Manage your to do List', 
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveSize.fontSize(20),
            color: cs.onSurface,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(ResponsiveSize.width(8)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surface.withValues(alpha: 0.2), 
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)), 
            ),
            child: Icon(
              Icons.search_rounded,
              size: ResponsiveSize.icon(24),
              color: cs.onSurface,
            ),
          ),
          onPressed: () => AppRouter.router.push(RouterPath.searchScreen),
        ),
        SizedBox(width: ResponsiveSize.width(8)),
      ],
    );
  }

  BoxDecoration _bgGradient(ColorScheme cs) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        cs.primary.withValues(alpha: 0.1),
        Colors.transparent
      ],
      stops: const [0.0, 0.3],
    ),
  );

  Widget _listView(List<ListTaskStats> lists) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(20),
        ResponsiveSize.height(110),
        ResponsiveSize.width(20),
        ResponsiveSize.height(100),
      ),
      separatorBuilder: (_, __) => SizedBox(height: ResponsiveSize.height(16)),
      itemCount: lists.length,
      itemBuilder: (_, i) {
        final stats = lists[i];
        return ListCard(
          list: stats.list,
          totalTasks: stats.totalTasks,
          doneTasks: stats.doneTasks,
          progress: stats.progress,
          cardColor: _getCardColor(i),
          onTap: () =>
              AppRouter.router.push(RouterPath.tasksScreen, extra: stats.list),
          onRename: () => _showRename(stats.list),
          onDelete: () => _showDelete(stats.list),
        );
      },
    );
  }
  
  // --- Existing List Logic methods ---

  Color _getCardColor(int index) {
    switch (index % 4) {
      case 0:
        return AppColors.cardColor1;
      case 1:
        return AppColors.cardColor2;
      case 2:
        return AppColors.cardColor3;
      case 3:
        return AppColors.cardColor4;
      default:
        return AppColors.cardColor4;
    }
  }

  Future<void> _retry() async {
    // Note: The RefreshIndicator expects a Future<void> return
    await ref.read(listsProvider.notifier).loadLists();
  }

  void _showCreate() => showCreateListDialog(
    context: context,
    title: 'Create New List',
    hint: 'e.g., Work, Personal, Ideas',
    onConfirm: (name) async {
      if (name.isNotEmpty) {
        try {
          await ref.read(listsProvider.notifier).addList(
            TaskList(id: _uuid.v4(), name: name, createdAt: DateTime.now()),
          );
          if (mounted) showCustomToast(context, message: 'List created successfully!', isSuccess: true);
        } catch (e) {
          if (mounted) showCustomToast(context, message: 'Failed to create list: $e', isSuccess: false);
        }
      }
    },
  );

  void _showRename(TaskList list) => showCreateListDialog(
    context: context,
    title: 'Rename List',
    initialValue: list.name,
    hint: 'New name',
    onConfirm: (name) async {
      if (name.isNotEmpty) {
        try {
          await ref.read(listsProvider.notifier).updateList(list.copyWith(name: name));
          if (mounted) showCustomToast(context, message: 'List renamed successfully!', isSuccess: true);
        } catch (e) {
          if (mounted) showCustomToast(context, message: 'Failed to rename list: $e', isSuccess: false);
        }
      }
    },
  );

  void _showDelete(TaskList list) => showDeleteConfirmationDialog(
    context: context,
    listName: list.name,
    onConfirm: () async {
      try {
        await ref.read(listsProvider.notifier).removeList(list.id);
        if (mounted) showCustomToast(context, message: 'List deleted successfully!', isSuccess: true);
      } catch (e) {
        if (mounted) showCustomToast(context, message: 'Failed to delete list: $e', isSuccess: false);
      }
    },
  );
}