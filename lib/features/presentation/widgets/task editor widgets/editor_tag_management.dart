// lib/features/presentation/widgets/task editor widgets/editor_tag_management.dart

import 'package:flutter/material.dart';
import 'package:task_management_app/features/data/models/task_tag.dart';
import 'package:task_management_app/features/presentation/provider/tag_notifier.dart';
import '../../../../task_core.dart';

class EditorTagManagement extends ConsumerWidget {
  final WidgetRef ref;
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final ValueChanged<List<Tag>> onSelectionChanged;
  final Uuid uuid;

  const EditorTagManagement({
    super.key,
    required this.ref,
    required this.tags,
    required this.selectedTags,
    required this.onSelectionChanged,
    required this.uuid,
  });

  @override
  Widget build(BuildContext context, WidgetRef watchRef) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: EdgeInsets.all(ResponsiveSize.width(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Tags',
                style: TextStyle(
                  fontSize: ResponsiveSize.fontSize(16),
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.add_rounded, size: ResponsiveSize.icon(18)),
                label: const Text('New'),
                onPressed: () => _showCreateTagDialog(context, tags, watchRef),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.width(12),
                    vertical: ResponsiveSize.height(8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveSize.height(12)),

          tags.isEmpty
              ? _buildEmptyTagState(cs)
              : Wrap(
                  spacing: ResponsiveSize.width(8),
                  runSpacing: ResponsiveSize.height(8),
                  children: tags.map((tag) {
                    final isSelected = selectedTags.any((t) => t.id == tag.id);
                    return FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        List<Tag> updatedList = List.from(selectedTags);
                        if (selected) {
                          updatedList.add(tag);
                        } else {
                          updatedList.removeWhere((t) => t.id == tag.id);
                        }
                        onSelectionChanged(updatedList);
                      },
                      avatar: Container(
                        width: ResponsiveSize.width(12),
                        height: ResponsiveSize.height(12),
                        decoration: BoxDecoration(
                          color: Color(tag.color),
                          shape: BoxShape.circle,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.width(12),
                        vertical: ResponsiveSize.height(8),
                      ),
                      labelStyle: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: ResponsiveSize.fontSize(14),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyTagState(ColorScheme cs) {
    return Container(
      padding: EdgeInsets.all(ResponsiveSize.width(12)),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
      ),
      child: Text(
        'No tags created yet.',
        style: TextStyle(
          color: cs.onSurfaceVariant,
          fontSize: ResponsiveSize.fontSize(14),
        ),
      ),
    );
  }

  void _showCreateTagDialog(
    BuildContext context,
    List<Tag> existingTags,
    WidgetRef ref,
  ) {
    final controller = TextEditingController();
    Color selectedColor = Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          // ... (simplified AlertDialog content from previous implementation) ...
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ResponsiveSize.radius(20)),
          ),
          title: const Text(
            'Create Tag',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Tag name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      ResponsiveSize.radius(12),
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: ResponsiveSize.height(24)),
              const Text(
                'Color',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: ResponsiveSize.height(12)),
              Wrap(
                spacing: ResponsiveSize.width(12),
                children:
                    [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                      Colors.pink,
                    ].map((color) {
                      final isSelected = selectedColor == color;
                      return GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          width: ResponsiveSize.width(44),
                          height: ResponsiveSize.height(44),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 3)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  final tag = Tag(
                    id: uuid.v4(),
                    name: name,
                    color: selectedColor.toARGB32(),
                  );
                  ref
                      .read(tagsProvider.notifier)
                      .addTag(tag)
                      .then((_) {
                        if (context.mounted) {
                          showCustomToast(
                            context,
                            message: 'Tag "$name" created!',
                            isSuccess: true,
                          );
                        }
                      })
                      .catchError((e) {
                        if (context.mounted) {
                          showCustomToast(
                            context,
                            message: 'Failed to create tag: $e',
                            isSuccess: false,
                          );
                        }
                      });
                  Navigator.pop(context);
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
