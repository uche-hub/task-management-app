import 'package:flutter/material.dart';

class SearchLoading extends StatelessWidget {
  const SearchLoading({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 3,
        valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
