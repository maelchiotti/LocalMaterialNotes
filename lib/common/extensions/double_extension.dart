import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Extends the [double] class with some utilities functions.
extension DoubleExtension on double {
  /// Returns the [double] formatted as a [String] with a percentage pattern.
  ///
  /// Uses the [locale] to determine the pattern if not null.
  String formatedAsPercentage({Locale? locale}) {
    final formatter = NumberFormat.percentPattern(locale?.languageCode);

    return formatter.format(this);
  }
}
