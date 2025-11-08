import 'package:flutter/material.dart';
import '../../../../task_core.dart';

class ListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ListAppBar({super.key, required this.cs});

  final ColorScheme cs;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.only(left: ResponsiveSize.width(4)),
        child: Text(
          'Manage your to do List',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveSize.fontSize(20),
            color: cs.onSurface,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(ResponsiveSize.width(8)),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.surface.withValues(alpha: 0.2),
              border: Border.all(color: cs.onSurface.withValues(alpha: 0.1)),
            ),
            child: Icon(
              Icons.search_rounded,
              size: ResponsiveSize.icon(24),
              color: cs.onSurface,
            ),
          ),
          onPressed: () => AppRouter.router.push(RouterPath.searchScreen),
        ),
        SizedBox(width: ResponsiveSize.width(8)),
      ],
    );
  }
}
