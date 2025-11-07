import 'package:flutter/material.dart';

import '../../../task_core.dart';

class ErrorState extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorState({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveSize.width(32)),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.sentiment_dissatisfied_rounded,
              size: ResponsiveSize.width(80), color: Colors.red[400]),
          SizedBox(height: ResponsiveSize.height(24)),
          Text('Oops! Something went wrong',
              style: TextStyle(
                  fontSize: ResponsiveSize.fontSize(20),
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800])),
          SizedBox(height: ResponsiveSize.height(12)),
          Text(error.toString(),
              style: TextStyle(color: Colors.grey[600], fontSize: ResponsiveSize.fontSize(14)),
              textAlign: TextAlign.center),
          SizedBox(height: ResponsiveSize.height(32)),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Try Again'),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveSize.width(32),
                  vertical: ResponsiveSize.height(16)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ]),
      ),
    );
  }
}