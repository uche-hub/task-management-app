import 'package:flutter/material.dart';
import '../../../../task_core.dart';

class ErrorStateWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ErrorState(
        error: error,
        onRetry: onRetry,
      ),
    );
  }
}
