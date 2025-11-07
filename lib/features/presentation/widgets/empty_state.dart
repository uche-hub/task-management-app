import 'package:flutter/material.dart';

import '../../../task_core.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveSize.width(32)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            SizedBox(height: ResponsiveSize.height(32)),
            _title(context),
            SizedBox(height: ResponsiveSize.height(12)),
            _subtitle(),
          ],
        ),
      ),
    );
  }

  Widget _icon() => Container(
    padding: EdgeInsets.all(ResponsiveSize.width(32)),
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(colors: [Colors.grey[300]!, Colors.grey[100]!]),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: Icon(
      Icons.inbox_rounded,
      size: ResponsiveSize.width(80),
      color: Colors.grey[600],
    ),
  );

  Widget _title(BuildContext context) => Text(
    'No lists yet',
    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.grey[800],
    ),
  );

  Widget _subtitle() => Text(
    'Tap the glowing button below to create your first list',
    style: TextStyle(
      fontSize: ResponsiveSize.fontSize(16),
      color: Colors.grey[600],
      height: 1.5,
    ),
    textAlign: TextAlign.center,
  );
}
