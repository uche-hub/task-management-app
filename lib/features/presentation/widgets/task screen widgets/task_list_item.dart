import 'package:flutter/material.dart';
import '../../../../task_core.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(task.status);
    final statusText = _getStatusText(task);
    final isOverdue = task.isOverdue; 

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveSize.height(16)),
        padding: EdgeInsets.all(ResponsiveSize.width(20)),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(ResponsiveSize.radius(24)),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Tag and Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatusChip(
                  text: statusText,
                  color: statusColor,
                  isOverdue: isOverdue,
                ),
                _OptionsButton(
                  onDelete: onDelete,
                  onToggle: onToggleComplete,
                  isDone: task.completed,
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(8)),

            // Title
            Text(
              task.title,
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(18),
                fontWeight: FontWeight.w700,
                decoration: task.completed ? TextDecoration.lineThrough : null,
                color: task.completed
                    ? cs.onSurface.withValues(alpha: 0.6)
                    : cs.onSurface,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(4)),

            Text(
              task.description ??
                  (task.tags.isNotEmpty
                      ? task.tags.map((t) => t.name).join(', ')
                      : 'No description'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(14),
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(12)),

            // Due Date & Feedback/Progress
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: ResponsiveSize.icon(16),
                  color: cs.onSurfaceVariant,
                ),
                SizedBox(width: ResponsiveSize.width(4)),
                Text(
                  task.dueDate == null
                      ? 'No Date'
                      : DateFormat('MMM d, yyyy').format(task.dueDate!),
                  style: TextStyle(
                    fontSize: ResponsiveSize.fontSize(14),
                    color: isOverdue ? Colors.red : cs.onSurfaceVariant,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const Spacer(),

                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: ResponsiveSize.icon(16),
                  color: cs.onSurfaceVariant,
                ),
                SizedBox(width: ResponsiveSize.width(4)),
                Text(
                  '${(task.title.length * 3) % 20 + 5} Feedback', // Mock Data
                  style: TextStyle(
                    fontSize: ResponsiveSize.fontSize(14),
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveSize.height(12)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return Colors.orange;
      case TaskStatus.done:
        return Colors.green;
      case TaskStatus.todo:
        return Colors.blue;
    }
  }

  String _getStatusText(Task task) {
    if (task.isOverdue && !task.completed) return 'Overdue';
    switch (task.status) {
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.done:
        return 'Done';
      case TaskStatus.todo:
        return 'To Do';
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final bool isOverdue;

  const _StatusChip({
    required this.text,
    required this.color,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = isOverdue ? Colors.red : color;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(12),
        vertical: ResponsiveSize.height(4),
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(10)),
        border: Border.all(color: chipColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.w600,
          fontSize: ResponsiveSize.fontSize(12),
        ),
      ),
    );
  }
}

class _OptionsButton extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final bool isDone;

  const _OptionsButton({
    required this.onDelete,
    required this.onToggle,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_horiz_rounded, color: cs.onSurfaceVariant),
      onSelected: (value) {
        if (value == 'toggle') {
          onToggle();
        } else if (value == 'delete') {
          onDelete();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'toggle',
          child: Text(isDone ? 'Mark To Do' : 'Mark Done'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
