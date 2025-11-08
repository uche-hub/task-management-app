import 'package:flutter/material.dart';
import 'package:task_management_app/task_core.dart';

class EditorStatusSegmented extends StatelessWidget {
  final TaskStatus selectedStatus;
  final ValueChanged<TaskStatus> onStatusChanged;

  const EditorStatusSegmented({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: SegmentedButton<TaskStatus>(
        segments: TaskStatus.values.map((status) {
          final label = status.toString().split('.').last.capitalize();
          final icon = status == TaskStatus.done
              ? Icons.check_circle_rounded
              : status == TaskStatus.inProgress
                  ? Icons.pending_rounded
                  : Icons.radio_button_unchecked_rounded;

          return ButtonSegment(
            value: status,
            label: Text(label),
            icon: Icon(icon, size: 18),
          );
        }).toList(),
        selected: {selectedStatus},
        onSelectionChanged: (s) => onStatusChanged(s.first),
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: cs.primary,
          selectedForegroundColor: Colors.white,
        ),
      ),
    );
  }
}
