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

  EdgeInsets get zero => EdgeInsets.zero;

  EdgeInsets get all => EdgeInsets.all(_padding);

  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: _padding);

  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: _padding);

  EdgeInsets get left => EdgeInsets.only(left: _padding);

  EdgeInsets get right => EdgeInsets.only(right: _padding);

  EdgeInsets get top => EdgeInsets.only(top: _padding);

  EdgeInsets get bottom => EdgeInsets.only(bottom: _padding);

  EdgeInsets get bottomSystemUi => EdgeInsets.only(bottom: MediaQuery.of(navigatorKey.currentContext!).padding.bottom);

  EdgeInsets get fab => const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 64);

  EdgeInsets get page => const EdgeInsets.all(16);

  EdgeInsets get pageButBottom => const EdgeInsets.only(top: 16, left: 16, right: 16);

  EdgeInsets get appBarActionsEnd => const EdgeInsets.only(right: 8);

  final double _padding;

  const Paddings(this._padding);
}
