import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

/// Basic app bar.
///
/// Contains:
///   - A back button if built with [BasicAppBar.back].
///   - The title of the current route.
class BasicAppBar extends StatefulWidget {
  /// Default constructor.
  const BasicAppBar() : showBack = false;

  /// App bar with a back button.
  const BasicAppBar.back() : showBack = true;

  /// Whether to show the back button.
  final bool showBack;

  @override
  State<BasicAppBar> createState() => _BasicAppBarState();
}

class _BasicAppBarState extends State<BasicAppBar> {
  void pop() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: widget.showBack ? BackButton(onPressed: pop) : null,
      title: Text(RoutingRoute.title(context)),
    );
  }
}
