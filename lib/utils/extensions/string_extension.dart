import 'package:intl/intl.dart';

extension StringExtension on String {
  String get capitalized {
    return toBeginningOfSentenceCase(this) ?? this;
  }

  bool get isStrongPassword {
    return RegExp(r'''^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"'[{\]}\|^]).{12,}$''')
        .hasMatch(this);
  }
}
