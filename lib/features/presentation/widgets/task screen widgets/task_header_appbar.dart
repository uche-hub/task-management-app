// lib/features/presentation/widgets/task screen widgets/task_header_appbar.dart

import 'package:flutter/material.dart';
import 'package:task_management_app/core/enum/task_filter.dart';
import '../../../../task_core.dart';

class TaskHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String listName;
  final TaskFilter currentFilter;
  final bool isFilterVisible; // <--- NEW PROP
  final Function(TaskFilter) onFilterChanged;
  final Function(SortOption) onSortSelected;
  final VoidCallback onFilterIconTap;

  const TaskHeaderAppBar({
    super.key,
    required this.listName,
    required this.currentFilter,
    required this.isFilterVisible, // <--- NEW
    required this.onFilterChanged,
    required this.onSortSelected,
    required this.onFilterIconTap, // <--- NEW
  });

  @override
  Size get preferredSize => Size.fromHeight(ResponsiveSize.height(130)); // Tall enough for title and tabs

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + ResponsiveSize.height(8),
      ),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.9),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            cs.primary.withValues(alpha: 0.05),
            cs.surface.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.4],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Search Icon
          Padding(
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    listName,
                    style: TextStyle(
                      fontSize: ResponsiveSize.fontSize(28),
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFilterVisible ? Icons.filter_alt_off_rounded : Icons.filter_alt_rounded,
                    color: isFilterVisible ? cs.primary : cs.onSurface,
                  ),
                  onPressed: onFilterIconTap,
                ),
                _buildSortMenu(cs),
              ],
            ),
          ),
          SizedBox(height: ResponsiveSize.height(16)),

          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width(20)),
            child: Row(
              children: TaskFilter.values
                  .map((filter) => _buildFilterChip(context, filter))
                  .toList(),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(8)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, TaskFilter filter) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = currentFilter == filter;

    String labelText = filter.name
        .replaceAllMapped(RegExp(r'(?<=[a-z])(?=[A-Z])'), (m) => ' ')
        .toUpperCase();

    if (filter == TaskFilter.all) labelText = 'ALL';

    return Padding(
      padding: EdgeInsets.only(right: ResponsiveSize.width(8)),
      child: ActionChip(
        label: Text(
          labelText,
          style: TextStyle(
            color: isSelected ? Colors.white : cs.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveSize.fontSize(14),
          ),
        ),
        onPressed: () => onFilterChanged(filter),
        backgroundColor: isSelected ? cs.primary : cs.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveSize.radius(16)),
          side: BorderSide(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: 1,
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(12),
          vertical: ResponsiveSize.height(6),
        ),
      ),
    );
  }

  Widget _buildSortMenu(ColorScheme cs) {
    // Sort Menu
    return PopupMenuButton<SortOption>(
      icon: Icon(Icons.sort, color: cs.onSurface),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SortOption.createdDate,
          child: Text('Date Created'),
        ),
        const PopupMenuItem(value: SortOption.dueDate, child: Text('Due Date')),
        const PopupMenuItem(
          value: SortOption.priority,
          child: Text('Priority'),
        ),
      ],
      onSelected: onSortSelected,
    );
  }
}
