import 'package:task_management_app/core/enum/task_priority.dart';
import 'package:task_management_app/core/enum/task_status.dart';
import 'package:task_management_app/features/data/models/task_tag.dart';

class Task {
  final String id;
  final String listId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final List<Tag> tags;

  Task({
    required this.id,
    required this.listId,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    required this.status,
    required this.createdAt,
    this.tags = const [],
  });

  bool get completed => status == TaskStatus.done;

  factory Task.fromMap(Map<String, dynamic> map, {List<Tag>? tags}) {
    return Task(
      id: map['id'] as String,
      listId: map['list_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['due_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['due_date'] as int)
          : null,
      priority: TaskPriority.fromValue(map['priority'] as int),
      status: TaskStatus.fromValue(map['status'] as String),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      tags: tags ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'list_id': listId,
      'title': title,
      'description': description,
      'due_date': dueDate?.millisecondsSinceEpoch,
      'priority': priority.value,
      'status': status.value,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  Task copyWith({
    String? id,
    String? listId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    List<Tag>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }

  // check if task is due soon
  bool get isDueSoon {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final difference = dueDate!.difference(now);
    return difference.inHours <= 48 && difference.inHours >= 0;
  }

  // check if task is overdue
  bool get isOverdue {
    if (dueDate == null || completed) return false;
    final today = DateTime.now();
    // Only compare date parts to check for overdue status
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    
    return taskDate.isBefore(todayDate);
  }
}
