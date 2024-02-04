// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

extension DateTimeExtensions on DateTime {
  String get yMMMMd_at_Hm {
    final localeName = localizations.localeName;

    final date = DateFormat.yMMMMd(localeName).format(this);
    final time = DateFormat.Hm(localeName).format(this);

    return '$date ${localizations.time_at} $time';
  }
}
