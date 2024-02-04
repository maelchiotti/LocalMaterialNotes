import 'package:flutter/material.dart';

// ignore: always_use_package_imports
import '../../routing/router_route.dart';

class EmptyAppBar extends StatelessWidget {
  const EmptyAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(RouterRoute.currentRoute.title),
    );
  }
}
