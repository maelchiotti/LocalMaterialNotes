import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';

// ignore_for_file: public_member_api_docs

/// Lists paddings between widgets.
enum Paddings {
  /// Allows to access custom paddings.
  custom(0),
  padding2(2),
  padding4(4),
  padding8(8),
  padding16(16),
  padding32(32),
  padding64(64),
  ;

  /// Padding to apply.
  final double _padding;

  const Paddings(this._padding);

  /// Size of the system bottom padding.
  double get _bottomSystemUiPadding => MediaQuery.of(rootNavigatorKey.currentContext!).viewPadding.bottom;

  /// Padding in all directions.
  EdgeInsetsDirectional get all => EdgeInsetsDirectional.all(_padding);

  /// Padding only on the start and end.
  EdgeInsetsDirectional get horizontal => EdgeInsetsDirectional.symmetric(horizontal: _padding);

  /// Padding only on the top and the bottom.
  EdgeInsetsDirectional get vertical => EdgeInsetsDirectional.symmetric(vertical: _padding);

  /// Padding only on the start.
  EdgeInsetsDirectional get left => EdgeInsetsDirectional.only(start: _padding);

  /// Padding only on the end.
  EdgeInsetsDirectional get right => EdgeInsetsDirectional.only(end: _padding);

  /// Padding only on the top.
  EdgeInsetsDirectional get top => EdgeInsetsDirectional.only(top: _padding);

  /// Padding only on the bottom.
  EdgeInsetsDirectional get bottom => EdgeInsetsDirectional.only(bottom: _padding);

  /// Padding equal to the system bottom padding.
  EdgeInsetsDirectional get bottomSystemUi => EdgeInsetsDirectional.only(bottom: _bottomSystemUiPadding);

  /// Padding for the floating action buttons.
  EdgeInsetsDirectional get fab => EdgeInsetsDirectional.only(
        bottom: _bottomSystemUiPadding + kFloatingActionButtonMargin + 64,
      );

  /// Padding for a page.
  EdgeInsetsDirectional get page => const EdgeInsetsDirectional.all(16);

  /// Padding for a page except the bottom.
  EdgeInsetsDirectional get pageButBottom => const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16);

  /// Padding for the end of the app bar.
  EdgeInsetsDirectional get appBarActionsEnd => const EdgeInsetsDirectional.only(end: 8);

  /// Padding for the notes list when the notes tiles have a background.
  EdgeInsetsDirectional get notesWithBackground => fab + const EdgeInsetsDirectional.symmetric(horizontal: 8);

  /// Padding for the separators in the notes list when the notes tiles have a background.
  EdgeInsetsDirectional get notesListWithBackgroundSeparation => const EdgeInsetsDirectional.symmetric(vertical: 4);
}
