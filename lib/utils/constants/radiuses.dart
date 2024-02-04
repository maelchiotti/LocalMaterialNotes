import 'package:flutter/material.dart';

enum Radiuses {
  custom(0),
  radius2(2),
  radius4(4),
  radius8(8),
  radius16(16),
  radius32(32),
  radius64(64),
  ;

  final double radius;

  BorderRadius get circular => BorderRadius.circular(radius);

  const Radiuses(this.radius);
}
