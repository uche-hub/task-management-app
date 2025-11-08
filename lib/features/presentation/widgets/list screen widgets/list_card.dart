import 'package:flutter/material.dart';
import '../../../../task_core.dart';

class ListCard extends StatelessWidget {
  final TaskList list;
  final int totalTasks;
  final int doneTasks;
  final double progress;
  final Color cardColor;
  final VoidCallback onTap;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const ListCard({
    super.key,
    required this.list,
    required this.totalTasks,
    required this.doneTasks,
    required this.progress,
    required this.cardColor,
    required this.onTap,
    required this.onRename,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // The delay calculation logic
    const delay = 400;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (_, value, child) => Transform.translate(
        offset: Offset(0, ResponsiveSize.height(50) * (1 - value)),
        child: Opacity(opacity: value, child: child),
      ),
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          decoration: BoxDecoration(
            color: cardColor.withValues(
              alpha: 0.9,
            ), // Slightly transparent solid color
            borderRadius: BorderRadius.circular(ResponsiveSize.width(24)),
            boxShadow: [
              BoxShadow(
                color: cardColor.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(ResponsiveSize.width(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Category Name & Options)
                _buildHeader(context),
                SizedBox(height: ResponsiveSize.height(8)),

                // Task Title
                _buildTitle(context),
                SizedBox(height: ResponsiveSize.height(16)),

                // Subtask Count & Progress
                _buildStatsAndProgress(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          list.name,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: ResponsiveSize.fontSize(14),
            fontWeight: FontWeight.w600,
          ),
        ),
        _popup(cs),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Tasks in ${list.name}',
      style: TextStyle(
        color: Colors.white,
        fontSize: ResponsiveSize.fontSize(22),
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatsAndProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtask Count (Done/Total)
        Text(
          '$doneTasks / $totalTasks tasks done', // Subtask count as per request
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: ResponsiveSize.fontSize(14),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveSize.height(8)),

        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: progress,
                minHeight: ResponsiveSize.height(6),
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                color: Colors.white,
                borderRadius: BorderRadius.circular(ResponsiveSize.radius(3)),
              ),
            ),
            SizedBox(width: ResponsiveSize.width(16)),
            Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white.withValues(alpha: 0.9),
              size: ResponsiveSize.icon(28),
            ),
          ],
        ),
      ],
    );
  }

  Widget _popup(ColorScheme cs) => PopupMenuButton<String>(
    icon: Icon(Icons.more_horiz_rounded, color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 10,
    color: cs.surface,
    itemBuilder: (_) => [
      _item('rename', 'Rename', Icons.edit_outlined, cs.onSurface),
      _item('delete', 'Delete', Icons.delete_outline, Colors.red),
    ],
    onSelected: (v) => v == 'rename' ? onRename() : onDelete(),
  );

  PopupMenuItem<String> _item(
    String value,
    String text,
    IconData icon,
    Color color,
  ) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveSize.width(6)),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          SizedBox(width: ResponsiveSize.width(12)),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: value == 'delete' ? Colors.red : color,
            ),
          ),
        ],
      ),
    );
  }
}
