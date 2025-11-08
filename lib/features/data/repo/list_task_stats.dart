import 'package:task_management_app/features/data/models/task_list.dart';

class ListTaskStats {
  final TaskList list;
  final int totalTasks;
  final int doneTasks;

  ListTaskStats({
    required this.list,
    required this.totalTasks,
    required this.doneTasks,
  });

  double get progress => totalTasks == 0 ? 0.0 : doneTasks / totalTasks;
}