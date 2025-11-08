import 'package:flutter/material.dart';

import '../../../../task_core.dart';

class SearchResultHeader extends StatelessWidget {
  final int count;
  const SearchResultHeader({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        ResponsiveSize.width(24),
        ResponsiveSize.height(20),
        ResponsiveSize.width(24),
        ResponsiveSize.height(12),
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Text(
        '$count result${count == 1 ? '' : 's'} found',
        style: TextStyle(
          fontSize: ResponsiveSize.fontSize(15),
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}