import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/back.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';

class BasicAppBar extends ConsumerWidget {
  const BasicAppBar() : showBack = false;

  const BasicAppBar.back() : showBack = true;

  final bool showBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: showBack ? BackButton(onPressed: () => back(context)) : null,
      title: Text(RouterRoute.currentRoute.title),
    );
  }
}
