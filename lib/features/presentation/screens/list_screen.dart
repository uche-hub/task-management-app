import 'package:flutter/material.dart';
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
    final cs = Theme.of(context).colorScheme;
    final listsAsync = ref.watch(listsProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appBar(cs),
      body: Container(
        decoration: _bgGradient(cs),
        child: listsAsync.when(
          loading: () => const ShimmerLoading(),
          error: (e, _) => ErrorState(error: e, onRetry: _retry),
          data: (lists) =>
              lists.isEmpty ? const EmptyState() : _listView(lists),
        ),
      ),
      floatingActionButton: ListsFAB(
        controller: _fabCtrl,
        onPressed: _showCreate,
      ),
    );
  }

  PreferredSizeWidget _appBar(ColorScheme cs) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'My Lists',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: ResponsiveSize.fontSize(28),
          foreground: Paint()
            ..shader = LinearGradient(
              colors: [cs.primary, cs.secondary],
            ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(ResponsiveSize.width(8)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(
              FontAwesome.search,
              size: 18,
              color: Colors.white,
            ),
          ),
          onPressed: () => AppRouter.router.push(RouterPath.searchScreen),
        ),
        SizedBox(width: ResponsiveSize.width(8)),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.primary.withOpacity(0.9), cs.primary.withOpacity(0.7)],
          ),
        ),
      ),
    );
  }

  BoxDecoration _bgGradient(ColorScheme cs) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [cs.primary.withOpacity(0.1), Colors.transparent],
      stops: const [0.0, 0.3],
    ),
  );

  Widget _listView(List<TaskList> lists) {
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
        final list = lists[i];
        return ListCard(
          list: list,
          onTap: () =>
              AppRouter.router.push(RouterPath.tasksScreen, extra: list),
          onRename: () => _showRename(list),
          onDelete: () => _showDelete(list),
        );
      },
    );
  }

  void _retry() => ref.read(listsProvider.notifier).loadLists();

  void _showCreate() => showCreateListDialog(
    context: context,
    title: 'Create New List',
    hint: 'e.g., Work, Personal, Ideas',
    onConfirm: (name) {
      if (name.isNotEmpty) {
        ref
            .read(listsProvider.notifier)
            .addList(
              TaskList(id: _uuid.v4(), name: name, createdAt: DateTime.now()),
            );
      }
    },
  );

  void _showRename(TaskList list) => showCreateListDialog(
    context: context,
    title: 'Rename List',
    initialValue: list.name,
    hint: 'New name',
    onConfirm: (name) {
      if (name.isNotEmpty) {
        ref.read(listsProvider.notifier).updateList(list.copyWith(name: name));
      }
    },
  );

  void _showDelete(TaskList list) => showDeleteConfirmationDialog(
    context: context,
    listName: list.name,
    onConfirm: () => ref.read(listsProvider.notifier).removeList(list.id),
  );
}
