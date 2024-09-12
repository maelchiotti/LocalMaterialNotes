import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/extensions/double_extension.dart';

// ignore_for_file: public_member_api_docs

/// Lists the localization completion for every supported language.
enum LocalizationCompletion {
  en(Locale('en'), 1), // English
  es(Locale('es'), .4), // Spanish
  fr(Locale('fr'), 1), // French
  pt(Locale('pt'), .77), // Portuguese
  ru(Locale('ru'), 0.8), // Russian
  tr(Locale('tr'), .39), // Turkish
  zh(Locale('zh'), .8), // Chinese Simplified
  ;

  /// The locale of this localization.
  final Locale locale;

  /// The percentage of strings that are localized for this [locale].
  ///
  /// The value is a double contained between 0 and 1.
  final double percentage;

  const LocalizationCompletion(this.locale, this.percentage);

  /// Returns the percentage of strings that are localized for the [locale], formatted as a [String] for the [locale].
  static String getFormattedPercentage(Locale locale) {
    final percentage = values.firstWhere((localizationSupport) {
      return localizationSupport.locale == locale;
    }).percentage;

    return percentage.formatedAsPercentage(locale: locale);
  }
}
