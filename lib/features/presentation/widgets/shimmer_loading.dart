import 'package:flutter/material.dart';

import '../../../task_core.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
          ResponsiveSize.width(20),
          ResponsiveSize.height(110),
          ResponsiveSize.width(20),
          ResponsiveSize.height(100)),
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: ResponsiveSize.height(16)),
      itemBuilder: (_, __) => Container(
        height: ResponsiveSize.height(90),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveSize.width(24)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(radius: ResponsiveSize.width(28), backgroundColor: Colors.white),
            title: Container(height: 16, color: Colors.white),
            subtitle: Container(
                height: 12,
                color: Colors.white,
                margin: EdgeInsets.only(top: ResponsiveSize.height(8))),
          ),
        ),
      ),
    );
  }
}