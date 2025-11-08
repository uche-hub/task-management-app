import 'package:flutter/material.dart';
import '../../task_core.dart';

void showCustomToast(
  BuildContext context, {
  required String message,
  required bool isSuccess,
}) {
  final color = isSuccess ? Colors.green : Colors.red;
  final icon = isSuccess ? Icons.check_circle_rounded : Icons.error_rounded;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white, size: ResponsiveSize.icon(20)),
          SizedBox(width: ResponsiveSize.width(12)),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveSize.fontSize(15),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: ResponsiveSize.width(12)),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveSize.radius(12)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveSize.width(16),
        vertical: ResponsiveSize.height(14),
      ),
      margin: EdgeInsets.only(
        bottom: ResponsiveSize.height(50),
        left: ResponsiveSize.width(20),
        right: ResponsiveSize.width(20),
      ),
    ),
  );
}