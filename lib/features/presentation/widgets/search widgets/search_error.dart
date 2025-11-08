import 'package:flutter/material.dart';
import 'package:task_management_app/core/utils/app_responsiveness.dart';

class SearchError extends StatelessWidget {
  final Object error;
  const SearchError({super.key, required this.error});
  @override
  Widget build(BuildContext context) => _emptyState(Icons.error_outline_rounded, 'Search failed', error.toString(), iconColor: Colors.red);
}

// Shared helper
Widget _emptyState(IconData icon, String title, String subtitle, {Color? iconColor}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: ResponsiveSize.icon(80), color: iconColor ?? Colors.grey[400]),
        SizedBox(height: ResponsiveSize.height(24)),
        Text(title, style: TextStyle(fontSize: ResponsiveSize.fontSize(22), fontWeight: FontWeight.bold)),
        SizedBox(height: ResponsiveSize.height(12)),
        Text(subtitle, style: TextStyle(fontSize: ResponsiveSize.fontSize(15), color: Colors.grey[600]), textAlign: TextAlign.center),
      ],
    ),
  );
}