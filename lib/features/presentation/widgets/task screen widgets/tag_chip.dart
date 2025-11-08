import 'package:flutter/material.dart';
import '../../../../task_core.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final bool isSelected;
  final Function(bool) onSelected;

  const TagChip({
    super.key,
    required this.tag,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = Color(tag.color);
    return ActionChip(
      label: Text(tag.name),
      onPressed: () => onSelected(!isSelected),
      avatar: CircleAvatar(
        backgroundColor: isSelected ? Colors.white : chipColor,
        radius: ResponsiveSize.radius(6),
        child: isSelected
            ? Icon(Icons.check, size: ResponsiveSize.icon(8), color: chipColor)
            : null,
      ),
      labelStyle: TextStyle(
        fontSize: ResponsiveSize.fontSize(12),
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
        color: isSelected ? Colors.white : chipColor.withValues(alpha: 0.8),
      ),
      backgroundColor: isSelected ? chipColor : chipColor.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(10)),
        side: BorderSide(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(8),
        vertical: ResponsiveSize.height(4),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
