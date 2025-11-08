class TaskList {
  final String id;
  final String name;
  final DateTime createdAt;

  TaskList({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  // convert from database row to object
  factory TaskList.fromMap(Map<String, dynamic> map) {
    return TaskList(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    );
  }

  // convert object to database row
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  // created a copy with some fields changed
  TaskList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
  }) {
    return TaskList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}