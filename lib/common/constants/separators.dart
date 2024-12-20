import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs

/// Lists separators between widgets.
enum Separator {
  divider1indent8(1, 1, 8, 8),
  divider1indent16(1, 1, 16, 16),
  divider1indent28(1, 1, 28, 28),
  ;

  /// Size of the separator.
  final double _size;

  /// Thickness of the separator.
  final double _thickness;

  /// Padding on the start of the separator.
  final double _indent;

  /// Padding on the end of the separator.
  final double _endIndent;

  const Separator(
    this._size,
    this._thickness,
    this._indent,
    this._endIndent,
  );

  /// Horizontal separator.
  Divider get horizontal => Divider(
        height: _size,
        thickness: _thickness,
        indent: _indent,
        endIndent: _endIndent,
      );

  /// Vertical separator.
  VerticalDivider get vertical => VerticalDivider(
        width: _size,
        thickness: _thickness,
        indent: _indent,
        endIndent: _endIndent,
      );
}
