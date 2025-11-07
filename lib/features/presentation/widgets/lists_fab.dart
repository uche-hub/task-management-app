import 'package:flutter/material.dart';

import '../../../task_core.dart';

class ListsFAB extends StatelessWidget {
  final AnimationController controller;
  final VoidCallback onPressed;

  const ListsFAB({super.key, required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ScaleTransition(
      scale: CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: cs.primary.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5),
          ],
        ),
        child: FloatingActionButton.extended(
          elevation: 0,
          highlightElevation: 0,
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          onPressed: onPressed,
          icon: Icon(Icons.add_rounded, size: ResponsiveSize.width(28)),
          label: Text('New List',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveSize.fontSize(16))),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)),
          extendedPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveSize.width(24),
              vertical: ResponsiveSize.height(16)),
        ),
      ),
    );
  }
}