import 'package:flutter/material.dart';
import '../../../../task_core.dart';
import '../../widgets/search widgets/search_result_header.dart';
import '../../widgets/search widgets/search_result_item.dart';

class SearchResultList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task) onTap;
  final void Function(Task) onToggle;
  final void Function(Task) onDelete;

  const SearchResultList({
    super.key,
    required this.tasks,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchResultHeader(count: tasks.length),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(
              ResponsiveSize.width(20),
              ResponsiveSize.height(12),
              ResponsiveSize.width(20),
              ResponsiveSize.height(100),
            ),
            separatorBuilder: (_, __) => SizedBox(height: ResponsiveSize.height(14)),
            itemCount: tasks.length,
            itemBuilder: (_, i) {
              final task = tasks[i];
              return SearchResultItem(
                task: task,
                onTap: () => onTap(task),
                onToggle: () => onToggle(task),
                onDelete: () => onDelete(task),
              );
            },
          ),
        ),
      ],
    );
  }
}