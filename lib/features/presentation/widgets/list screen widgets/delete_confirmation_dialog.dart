// lib/widgets/delete_confirmation_dialog.dart
import 'package:flutter/material.dart';

import '../../../../task_core.dart';

void showDeleteConfirmationDialog({
  required BuildContext context,
  required String listName,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(children: [
        Icon(Icons.warning_amber_rounded,
            color: Colors.red[600], size: ResponsiveSize.width(28)),
        SizedBox(width: ResponsiveSize.width(12)),
        const Text('Delete List?', style: TextStyle(fontWeight: FontWeight.bold)),
      ]),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 15),
          children: [
            const TextSpan(text: 'This will permanently delete '),
            TextSpan(
                text: '"$listName"',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const TextSpan(text: ' and all its tasks.\n\nThis cannot be undone.'),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 16))),
        FilledButton(
          style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(24),
                  vertical: ResponsiveSize.height(12))),
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}