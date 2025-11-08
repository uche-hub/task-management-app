import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../task_core.dart';

class SearchAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    final controller = TextEditingController(text: query)
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: query.length),
      );

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        height: ResponsiveSize.height(48),
        margin: EdgeInsets.only(right: ResponsiveSize.width(12)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(fontSize: ResponsiveSize.fontSize(16)),
              decoration: InputDecoration(
                hintText: 'Search tasks by title or tags',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveSize.fontSize(14),
                ),
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: ResponsiveSize.icon(22),
                  color: Colors.grey[500],
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.height(12),
                ),
              ),
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
            ),
          ),
        ),
      ),
      actions: [
        if (query.isNotEmpty)
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(ResponsiveSize.width(8)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Icon(Icons.clear_rounded, color: Colors.white),
            ),
            onPressed: () {
              controller.clear();
              ref.read(searchQueryProvider.notifier).state = '';
            },
          ),
        SizedBox(width: ResponsiveSize.width(8)),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            ],
          ),
        ),
      ),
    );
  }
}