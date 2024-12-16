import 'package:flutter/material.dart';

/// Basic app bar.
///
/// Contains:
///   - A back button if built with [BasicAppBar.back].
///   - The title of the current route.
class BasicAppBar extends StatelessWidget {
  /// Default constructor.
  const BasicAppBar({
    super.key,
    required this.title,
    this.back = false,
  });

  /// Title to display in the app bar.
  final String title;

  /// Whether to show the back button.
  final bool back;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
    );
  }
}
