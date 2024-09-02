import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/bin/bin_page.dart';

@immutable
class BinRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BinPage();
  }
}
