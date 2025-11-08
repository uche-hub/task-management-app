// lib/widgets/create_list_dialog.dart
import 'package:flutter/material.dart';

import '../../../../task_core.dart';

void showCreateListDialog({
  required BuildContext context,
  required String title,
  required Function(String) onConfirm,
  String? initialValue,
  String? hint,
}) {
  final ctrl = TextEditingController(text: initialValue);

  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      elevation: 20,
      child: Container(
        padding: EdgeInsets.all(ResponsiveSize.width(28)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[50]!]),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title,
              style: TextStyle(
                  fontSize: ResponsiveSize.fontSize(22),
                  fontWeight: FontWeight.bold)),
          SizedBox(height: ResponsiveSize.height(20)),
          TextField(
            controller: ctrl,
            autofocus: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: ResponsiveSize.fontSize(18)),
            decoration: InputDecoration(
              hintText: hint ?? 'Enter name',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(
                  vertical: ResponsiveSize.height(18),
                  horizontal: ResponsiveSize.width(20)),
            ),
          ),
          SizedBox(height: ResponsiveSize.height(28)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel',
                    style: TextStyle(color: Colors.grey[600], fontSize: ResponsiveSize.fontSize(16)))),
            SizedBox(width: ResponsiveSize.width(12)),
            FilledButton(
              onPressed: () {
                final txt = ctrl.text.trim();
                if (txt.isNotEmpty) {
                  onConfirm(txt);
                  Navigator.pop(context);
                }
              },
              style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.width(28),
                      vertical: ResponsiveSize.height(14)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              child: Text(title.contains('Create') ? 'Create' : 'Save',
                  style: TextStyle(
                      fontSize: ResponsiveSize.fontSize(16),
                      fontWeight: FontWeight.bold)),
            ),
          ]),
        ]),
      ),
    ),
  );
}