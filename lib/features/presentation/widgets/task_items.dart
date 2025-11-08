import 'package:flutter/material.dart';

import '../../../task_core.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.done;
    final isDueSoon = task.isDueSoon;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        // checkbox to mark complete
        leading: Semantics(
          label: isDone ? 'Mark as incomplete' : 'Mark as complete',
          child: Checkbox(
            value: isDone,
            onChanged: (_) => onToggleComplete(),
          ),
        ),
        
        title: Text(
          task.title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone ? Colors.grey : null,
          ),
        ),
        
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null) ...[
              const SizedBox(height: 4),
              Text(
                task.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDone ? Colors.grey : null,
                ),
              ),
            ],
            
            const SizedBox(height: 4),
            
            Row(
              children: [
                // priority badge
                _PriorityBadge(priority: task.priority),
                
                const SizedBox(width: 8),
                
                // due date
                if (task.dueDate != null) ...[
                  Icon(
                    Icons.calendar_today,
                    size: 12,
                    color: isDueSoon ? Colors.orange : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d').format(task.dueDate!),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDueSoon ? Colors.orange : Colors.grey,
                      fontWeight: isDueSoon ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ],
            ),
            
            // tags
            if (task.tags.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: task.tags.map((tag) {
                  return Chip(
                    label: Text(
                      tag.name,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: Color(tag.color).withValues(alpha:0.2),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          onSelected: (_) => onDelete(),
        ),
        
        onTap: onTap,
      ),
    );
  }
}

// shows priority with color
class _PriorityBadge extends StatelessWidget {
  final TaskPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (priority) {
      case TaskPriority.low:
        color = Colors.blue;
        text = 'Low';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        text = 'Med';
        break;
      case TaskPriority.high:
        color = Colors.red;
        text = 'High';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha:0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}