import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';

/// Basic app bar.
///
/// Contains:
///   - A back button if built with [BasicAppBar.back].
///   - The title of the current route.
class BasicAppBar extends StatefulWidget {
  /// Default constructor.
  const BasicAppBar({super.key}) : showBack = false;

  /// App bar with a back button.
  const BasicAppBar.back({super.key}) : showBack = true;

  /// Whether to show the back button.
  final bool showBack;

  @override
  State<BasicAppBar> createState() => _BasicAppBarState();
}

class _BasicAppBarState extends State<BasicAppBar> {
  void _pop() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.showBack ? BackButton(onPressed: _pop) : null,
      title: Text(context.title(context)),
    );
  }
}
