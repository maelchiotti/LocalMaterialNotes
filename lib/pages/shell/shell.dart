import 'package:flutter/material.dart';

/// Shell that contains the current page.
class ShellPage extends StatelessWidget {
  /// Default constructor.
  const ShellPage({
    super.key,
    required this.child,
  });

  /// The page to show.
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
