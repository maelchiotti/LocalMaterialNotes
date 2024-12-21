import 'dart:ui';

import 'package:intl/intl.dart' as intl;
import '../../utils/locale_utils.dart';

/// Extends the [Locale] class with some utilities functions.
extension LocaleExtension on Locale {
  /// Returns the text direction (RTL or LTR) according to the locale of the device (not the locale of the application).
  TextDirection get textDirection {
    final deviceLanguageCode = LocaleUtils().deviceLocale.languageCode;
    final textDirection = intl.Bidi.isRtlLanguage(deviceLanguageCode) ? TextDirection.rtl : TextDirection.ltr;

    return textDirection;
  }
}
