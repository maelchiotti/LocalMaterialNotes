import 'dart:ui';

import 'package:intl/intl.dart' as intl;
import 'package:localmaterialnotes/utils/locale_utils.dart';

extension LocaleExtension on Locale {
  TextDirection get textDirection {
    return intl.Bidi.isRtlLanguage(LocaleUtils().deviceLocale.languageCode) ? TextDirection.rtl : TextDirection.ltr;
  }
}
