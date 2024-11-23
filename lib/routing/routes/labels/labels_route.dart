import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localmaterialnotes/pages/labels/labels_page.dart';

/// Route of the labels page.
@immutable
class LabelsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LabelsPage();
  }
}
