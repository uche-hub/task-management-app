import 'package:flutter/material.dart';
import 'package:task_management_app/features/data/models/task_list.dart';
import 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/list_app_bar.dart';
import 'package:task_management_app/features/presentation/widgets/list%20screen%20widgets/list_items_view.dart';
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
      appBar: ListAppBar(cs: cs),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [cs.primary.withValues(alpha: 0.1), Colors.transparent],
            stops: const [0.0, 0.3],
          ),
        ),
        child: listsAsync.when(
          loading: () => const CustomLoader(),
          error: (e, _) => ErrorState(error: e, onRetry: _retry),
          data: (lists) => lists.isEmpty
              ? const EmptyState()
              : ListItemsView(
                  lists: lists,
                  onRefresh: _retry,
                  onTap: (list) => AppRouter.router.push(RouterPath.tasksScreen, extra: list),
                  onRename: _showRename,
                  onDelete: _showDelete,
                ),
        ),
      ),
      floatingActionButton: ListsFAB(controller: _fabCtrl, onPressed: _showCreate),
    );
  }

  Future<void> _retry() async => ref.read(listsProvider.notifier).loadLists();

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