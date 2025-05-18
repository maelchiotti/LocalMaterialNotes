import 'package:flutter/material.dart';

/// Widgets separator.
class Separator extends StatelessWidget {
  /// Horizontal separator between two widgets.
  const Separator.horizontal({super.key, required this.indent}) : _horizontal = true;

  /// Vertical separator between two widgets.
  const Separator.vertical({super.key, required this.indent}) : _horizontal = false;

  /// The start and end indent.
  final double indent;

  /// Whether this separator is horizontal.
  final bool _horizontal;

  @override
  Widget build(BuildContext context) {
    return _horizontal
        ? Divider(height: 1, thickness: 1, indent: indent, endIndent: indent)
        : VerticalDivider(width: 1, thickness: 1, indent: indent, endIndent: indent);
  }
}
