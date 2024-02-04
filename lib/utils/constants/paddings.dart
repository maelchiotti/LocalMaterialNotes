import 'package:flutter/material.dart';

enum Paddings {
  custom(0),
  padding2(2),
  padding4(4),
  padding8(8),
  padding16(16),
  padding32(32),
  padding64(64),
  ;

  EdgeInsets get zero => EdgeInsets.zero;

  EdgeInsets get all => EdgeInsets.all(_padding);

  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: _padding);

  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: _padding);

  EdgeInsets get left => EdgeInsets.only(left: _padding);

  EdgeInsets get right => EdgeInsets.only(right: _padding);

  EdgeInsets get top => EdgeInsets.only(top: _padding);

  EdgeInsets get bottom => EdgeInsets.only(bottom: _padding);

  EdgeInsets get fab => const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 64);

  EdgeInsets get miniFab => const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48);

  EdgeInsets get page => const EdgeInsets.all(16);

  EdgeInsets get pageButBottom => const EdgeInsets.only(top: 16, left: 16, right: 16);

  EdgeInsets get pageHorizontal => const EdgeInsets.symmetric(horizontal: 16);

  EdgeInsets get pageVertical => const EdgeInsets.symmetric(vertical: 16);

  EdgeInsets get drawer => const EdgeInsets.all(8);

  EdgeInsets get editorDesktop => const EdgeInsets.all(16);

  EdgeInsets get editorMobile => const EdgeInsets.all(4);

  EdgeInsets get appBarActionsEnd => const EdgeInsets.only(right: 8);

  final double _padding;

  const Paddings(this._padding);
}
