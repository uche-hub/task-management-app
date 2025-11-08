import 'package:flutter/material.dart';
import '../../../../../../task_core.dart';

class TaskOptionsButton extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onToggle;
  final bool isDone;

  const TaskOptionsButton({
    super.key, 
    required this.onDelete, 
    required this.onToggle, 
    required this.isDone
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
      ),
      elevation: 8,
    );
  }
}