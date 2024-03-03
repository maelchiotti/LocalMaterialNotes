import 'package:flutter/material.dart';

enum Separator {
  divider1indent8(1, 1, 8, 8),
  divider1indent16(1, 1, 16, 16),
  ;

  final double _size;
  final double _thickness;
  final double _indent;
  final double _endIndent;

  Divider get horizontal => Divider(
        height: _size,
        thickness: _thickness,
        indent: _indent,
        endIndent: _endIndent,
      );

  VerticalDivider get vertical => VerticalDivider(
        width: _size,
        thickness: _thickness,
        indent: _indent,
        endIndent: _endIndent,
      );

  const Separator(
    this._size,
    this._thickness,
    this._indent,
    this._endIndent,
  );
}
