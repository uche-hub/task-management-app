enum TaskStatus {
  todo,
  inProgress,
  done;

  String get value {
    switch (this) {
      case TaskStatus.todo:
        return 'todo';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.done:
        return 'done';
    }
  }

  static TaskStatus fromValue(String value) {
    switch (value) {
      case 'todo':
        return TaskStatus.todo;
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'done':
        return TaskStatus.done;
      default:
        return TaskStatus.todo;
    }
  }
}