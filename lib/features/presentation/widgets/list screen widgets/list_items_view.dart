import 'package:flutter/material.dart';
import 'package:task_management_app/features/data/models/task_list.dart';
import 'package:task_management_app/features/data/repo/list_task_stats.dart';
import '../../../../task_core.dart';

class ListItemsView extends StatelessWidget {
  final List<ListTaskStats> lists;
  final Future<void> Function() onRefresh;
  final void Function(TaskList list) onTap;
  final void Function(TaskList list) onRename;
  final void Function(TaskList list) onDelete;

  const ListItemsView({
    super.key,
    required this.lists,
    required this.onRefresh,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: ListView.separated(
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
            onTap: () => onTap(stats.list),
            onRename: () => onRename(stats.list),
            onDelete: () => onDelete(stats.list),
          );
        },
      ),
    );
  }

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
}
