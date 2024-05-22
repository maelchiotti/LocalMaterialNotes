import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

enum Paddings {
  custom(0),
  padding2(2),
  padding4(4),
  padding8(8),
  padding16(16),
  padding32(32),
  padding64(64),
  ;

  double get _bottomSystemUiPadding => MediaQuery.of(navigatorKey.currentContext!).viewPadding.bottom;

  EdgeInsetsDirectional get zero => EdgeInsetsDirectional.zero;

  EdgeInsetsDirectional get all => EdgeInsetsDirectional.all(_padding);

  EdgeInsetsDirectional get horizontal => EdgeInsetsDirectional.symmetric(horizontal: _padding);

  EdgeInsetsDirectional get vertical => EdgeInsetsDirectional.symmetric(vertical: _padding);

  EdgeInsetsDirectional get left => EdgeInsetsDirectional.only(start: _padding);

  EdgeInsetsDirectional get right => EdgeInsetsDirectional.only(end: _padding);

  EdgeInsetsDirectional get top => EdgeInsetsDirectional.only(top: _padding);

  EdgeInsetsDirectional get bottom => EdgeInsetsDirectional.only(bottom: _padding);

  EdgeInsetsDirectional get bottomSystemUi => EdgeInsetsDirectional.only(bottom: _bottomSystemUiPadding);

  EdgeInsetsDirectional get fab => EdgeInsetsDirectional.only(
        bottom: _bottomSystemUiPadding + kFloatingActionButtonMargin + 64,
      );

  EdgeInsetsDirectional get page => const EdgeInsetsDirectional.all(16);

  EdgeInsetsDirectional get pageButBottom => const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16);

  EdgeInsetsDirectional get appBarActionsEnd => const EdgeInsetsDirectional.only(end: 8);

  EdgeInsetsDirectional get editorWithToolbar => const EdgeInsetsDirectional.only(bottom: 64);

  final double _padding;

  const Paddings(this._padding);
}
