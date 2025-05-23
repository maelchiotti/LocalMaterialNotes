// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'build_context_extension.dart';

/// Extends the [DateTime] class with some utilities functions.
extension DateTimeExtensions on DateTime {
  /// Returns the date and time formatted to use in a file's name.
  ///
  /// Pattern: `dd-MM-yyyy_HH-mm-ss`.
  String get filename => DateFormat('dd-MM-yyyy_HH-mm-ss').format(this);

  /// Returns the date and time formatted to use in a log file.
  ///
  /// Pattern: `dd/MM/yyyy - HH:mm:ss`.
  String get log => DateFormat('dd/MM/yyyy - HH:mm:ss').format(this);

  /// Returns the date and time formatted in a readable manner, according to the current locale.
  ///
  /// Pattern: `{date} at {time}`.
  String yMMMMd_at_Hm(BuildContext context) {
    final localeName = context.l.localeName;

    final date = DateFormat.yMMMMd(localeName).format(this);
    final time = DateFormat.Hm(localeName).format(this);

    return '$date ${context.l.about_time_at} $time';
  }
}
