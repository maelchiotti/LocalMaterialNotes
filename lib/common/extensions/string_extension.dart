import 'package:intl/intl.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';

/// Extends the [String] class with some utilities functions.
extension StringExtension on String {
  /// Returns the string with the first letter capitalized according to the current locale.
  String get capitalized {
    final appLocaleLanguageCode = LocaleUtils().appLocale.languageCode;

    return toBeginningOfSentenceCase(this, appLocaleLanguageCode) ?? this;
  }

  /// Returns whether the password is a strong one.
  ///
  /// A strong password must contain at least:
  ///   - 1 lowercase
  ///   - 1 uppercase
  ///   - 1 number
  ///   - 1 special character
  bool get isStrongPassword {
    final regex = RegExp(
      r'''^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"'[{\]}\|^]).{12,}$''',
    );

    return regex.hasMatch(this);
  }
}
