import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs

/// Lists radiuses of widgets.
enum Radiuses {
  /// Allows to access custom radiuses.
  custom(0),
  radius2(2),
  radius4(4),
  radius8(8),
  radius16(16),
  radius32(32),
  radius64(64),
  ;

  /// Radius to apply.
  final double _radius;

  const Radiuses(this._radius);

  /// Circular radius.
  BorderRadius get circular => BorderRadius.circular(_radius);
}
