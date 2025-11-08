import 'package:flutter/material.dart';

class EditorTagErrorState extends StatelessWidget {
  const EditorTagErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.error),
          const SizedBox(width: 12),
          Text('Could not load tags', style: TextStyle(color: cs.error)),
        ],
      ),
    );
  }
}
