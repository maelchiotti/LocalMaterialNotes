import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/sizes.dart';

// ignore_for_file: avoid_classes_with_only_static_members

/// Lists paddings between widgets.
class Paddings {
  /// Size of the system bottom padding.
  static double get _bottomSystemUiPadding => MediaQuery.of(rootNavigatorKey.currentContext!).viewPadding.bottom;

  /// Padding in all directions.
  static EdgeInsetsDirectional all(double padding) {
    return EdgeInsetsDirectional.all(padding);
  }

  /// Padding only on the start and end.
  static EdgeInsetsDirectional horizontal(double padding) {
    return EdgeInsetsDirectional.symmetric(horizontal: padding);
  }

  /// Padding only on the top and the bottom.
  static EdgeInsetsDirectional vertical(double padding) {
    return EdgeInsetsDirectional.symmetric(vertical: padding);
  }

  /// Padding only on the start.
  static EdgeInsetsDirectional left(double padding) {
    return EdgeInsetsDirectional.only(start: padding);
  }

  /// Padding only on the end.
  static EdgeInsetsDirectional right(double padding) {
    return EdgeInsetsDirectional.only(end: padding);
  }

  /// Padding only on the top.
  static EdgeInsetsDirectional top(double padding) {
    return EdgeInsetsDirectional.only(top: padding);
  }

  /// Padding only on the bottom.
  static EdgeInsetsDirectional bottom(double padding) {
    return EdgeInsetsDirectional.only(bottom: padding);
  }

  /// Padding equal to the system bottom padding.
  static EdgeInsetsDirectional get bottomSystemUi {
    return EdgeInsetsDirectional.only(bottom: _bottomSystemUiPadding);
  }

  /// Padding for the floating action buttons.
  static EdgeInsetsDirectional get fab {
    return EdgeInsetsDirectional.only(
      bottom: _bottomSystemUiPadding + kFloatingActionButtonMargin + 64,
    );
  }

  /// Padding for a page.
  static EdgeInsetsDirectional get page {
    return const EdgeInsetsDirectional.all(16);
  }

  /// Padding for a page except the bottom.
  static EdgeInsetsDirectional get pageButBottom {
    return const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16);
  }

  /// Padding for the end of the app bar.
  static EdgeInsetsDirectional get appBarActionsEnd {
    return const EdgeInsetsDirectional.only(end: 8);
  }

  /// Padding for the notes list when the notes tiles have a background.
  static EdgeInsetsDirectional get notesWithBackground {
    return fab + const EdgeInsetsDirectional.symmetric(horizontal: 8);
  }

  /// Padding for the separators in the notes list when the notes tiles have a background.
  static EdgeInsetsDirectional get notesListWithBackgroundSeparation {
    return const EdgeInsetsDirectional.symmetric(vertical: 4);
  }

  /// Padding for the separators in the notes list when the notes tiles have a background.
  static EdgeInsetsDirectional get fabToggleEditorModeWithToolbarBottom {
    return EdgeInsetsDirectional.only(
      bottom: Sizes.editorToolbarHeight.size,
    );
  }
}
