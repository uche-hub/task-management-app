import 'package:flutter/material.dart';
import '../../task_core.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: ResponsiveSize.width(80),
        height: ResponsiveSize.height(80),
        padding: EdgeInsets.all(ResponsiveSize.width(16)),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(ResponsiveSize.radius(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CircularProgressIndicator(
          strokeWidth: ResponsiveSize.width(4),
          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}