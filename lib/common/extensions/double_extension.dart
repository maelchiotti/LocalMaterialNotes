import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DoubleExtension on double {
  String formatedAsPercentage({Locale? locale}) {
    final formatter = NumberFormat.percentPattern(locale?.languageCode);

    return formatter.format(this);
  }
}
