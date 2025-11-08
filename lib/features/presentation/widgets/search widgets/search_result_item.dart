import 'package:flutter/material.dart';
import '../../../../task_core.dart';

class SearchResultItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const SearchResultItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDone = task.completed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(4)),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(16),
          vertical: ResponsiveSize.height(12),
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(ResponsiveSize.radius(16)),
          boxShadow: [
            BoxShadow(
              color: cs.onSurface.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5), width: 1),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leading Checkbox/Indicator
            GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: EdgeInsets.only(top: ResponsiveSize.height(4)),
                child: Icon(
                  isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                  color: isDone ? Colors.green : cs.primary,
                  size: ResponsiveSize.icon(24),
                ),
              ),
            ),
            SizedBox(width: ResponsiveSize.width(12)),

            // Title and Tags
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: ResponsiveSize.fontSize(17),
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      color: isDone ? cs.onSurfaceVariant : cs.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ResponsiveSize.height(4)),
                  // Show containing List ID or Tags as subtitle
                  if (task.tags.isNotEmpty)
                    Wrap(
                      spacing: ResponsiveSize.width(6),
                      runSpacing: ResponsiveSize.height(4),
                      children: task.tags.take(3).map((tag) => Chip(
                            label: Text(
                              tag.name,
                              style: TextStyle(fontSize: ResponsiveSize.fontSize(10), color: Color(tag.color)),
                            ),
                            backgroundColor: Color(tag.color).withValues(alpha: 0.1),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          )).toList(),
                    )
                  else
                    Text(
                      'List: ${task.listId}',
                      style: TextStyle(fontSize: ResponsiveSize.fontSize(13), color: cs.onSurfaceVariant),
                    ),
                ],
              ),
            ),

            // Trailing Options
            TaskOptionsButton(
              onDelete: onDelete,
              onToggle: onToggle,
              isDone: isDone,
            ),
          ],
        ),
      ),
    );
  }
}