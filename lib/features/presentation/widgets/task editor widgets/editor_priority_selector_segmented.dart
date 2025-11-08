import 'package:flutter/material.dart';
import '../../../../task_core.dart';

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
    }
}

class EditorPrioritySelectorSegmented extends StatelessWidget {
  final TaskPriority selectedPriority;
  final ValueChanged<TaskPriority> onPrioritySelected;

  const EditorPrioritySelectorSegmented({
    super.key,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(4)),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(16)),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: TaskPriority.values.map((priority) {
            final isSelected = selectedPriority == priority;
            final color = _getPriorityColor(priority);

            return Expanded(
              child: GestureDetector(
                onTap: () => onPrioritySelected(priority),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveSize.height(12),
                    horizontal: ResponsiveSize.width(8),
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    priority.toString().split('.').last.capitalize(),
                    style: TextStyle(
                      fontSize: ResponsiveSize.fontSize(16),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? color : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
      return Colors.blue;
    }
  }
}