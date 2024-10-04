import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/bin/bin_page.dart';
import 'package:localmaterialnotes/utils/keys.dart';

/// Route of the bin page.
@immutable
class BinRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const BinPage(
      key: Keys.pageBin,
    );
  }
}
