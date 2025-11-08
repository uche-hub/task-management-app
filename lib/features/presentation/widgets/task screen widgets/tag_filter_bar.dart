import 'package:flutter/material.dart';
import 'package:task_management_app/features/presentation/provider/tag_notifier.dart';
import 'package:task_management_app/features/presentation/provider/tasks_notifier.dart';
import '../../../../task_core.dart';
import 'tag_chip.dart';

class TagFilterBar extends ConsumerWidget {
  final String listId;
  final List<String> selectedTagIds;
  final Function(List<String>) onTagSelected;

  const TagFilterBar({
    super.key,
    required this.listId,
    required this.selectedTagIds,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(tagsProvider);

    return tagsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (tags) {
        if (tags.isEmpty) return const SizedBox.shrink();
        return Container(
          padding: EdgeInsets.fromLTRB(
            ResponsiveSize.width(20),
            ResponsiveSize.height(8),
            ResponsiveSize.width(20),
            ResponsiveSize.height(8),
          ),
          child: Wrap(
            spacing: ResponsiveSize.width(8),
            runSpacing: ResponsiveSize.height(4),
            children: tags.map((tag) {
              final isSelected = selectedTagIds.contains(tag.id);
              return TagChip(
                tag: tag,
                isSelected: isSelected,
                onSelected: (selected) {
                  final updated = List<String>.from(selectedTagIds);
                  if (selected) {
                    updated.add(tag.id);
                  } else {
                    updated.remove(tag.id);
                  }
                  onTagSelected(updated);
                  ref
                      .read(tasksProvider(listId).notifier)
                      .filterByTags(updated);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
