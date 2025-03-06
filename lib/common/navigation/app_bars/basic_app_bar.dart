import 'package:flutter/material.dart';

/// Basic app bar.
class BasicAppBar extends StatelessWidget {
  /// A basic app bar with a title.
  const BasicAppBar({super.key, required this.title});

  /// Title to display in the app bar.
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(title: Text(title));
  }
}
