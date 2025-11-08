import 'package:flutter/material.dart';

import '../../../../task_core.dart';

class SearchNoResults extends StatelessWidget {
  const SearchNoResults({super.key});
  @override
  Widget build(BuildContext context) => _emptyState(Icons.search_off_rounded, 'No results found', 'Try a different search term');
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