import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';

class BasicAppBar extends StatefulWidget {
  const BasicAppBar() : showBack = false;

  const BasicAppBar.back() : showBack = true;

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
      title: Text(RouterRoute.currentRoute.title),
    );
  }
}
