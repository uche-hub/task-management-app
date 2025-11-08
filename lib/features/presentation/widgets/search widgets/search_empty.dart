// lib/widgets/search_empty.dart
import 'package:flutter/material.dart';
import 'package:task_management_app/core/utils/app_responsiveness.dart';

class SearchEmpty extends StatelessWidget {
  const SearchEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(ResponsiveSize.width(32)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Colors.grey[200]!, Colors.grey[50]!]),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
            ),
            child: Icon(Icons.search_rounded, size: ResponsiveSize.icon(80), color: Colors.grey[600]),
          ),
          SizedBox(height: ResponsiveSize.height(32)),
          Text('Search for tasks', style: TextStyle(fontSize: ResponsiveSize.fontSize(24), fontWeight: FontWeight.bold)),
          SizedBox(height: ResponsiveSize.height(12)),
          Text('Type to search by title or tags', style: TextStyle(fontSize: ResponsiveSize.fontSize(16), color: Colors.grey[600]), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}