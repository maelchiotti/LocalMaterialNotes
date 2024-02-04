import 'package:intl/intl.dart';

extension StringExtension on String {
  String get capitalized {
    return toBeginningOfSentenceCase(this) ?? this;
  }
}
