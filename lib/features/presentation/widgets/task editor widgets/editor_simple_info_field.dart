import 'package:flutter/material.dart';

class EditorSimpleInfoField extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const EditorSimpleInfoField({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          Icon(icon, size: 18, color: color.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}
