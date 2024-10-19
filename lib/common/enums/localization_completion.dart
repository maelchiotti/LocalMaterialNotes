import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/extensions/double_extension.dart';

// ignore_for_file: public_member_api_docs

/// Lists the localization completion for every supported language.
enum LocalizationCompletion {
  /// English.
  en(Locale('en'), 1),

  /// Spanish.
  es(Locale('es'), .88),

  /// French.
  fr(Locale('fr'), 1),

  /// German.
  de(Locale('de'), .88),

  /// Portuguese.
  pt(Locale('pt'), .62),

  /// Russian.
  ru(Locale('ru'), 0.67),

  /// Turkish.
  tr(Locale('tr'), .97),

  /// Chinese Simplified.
  zh(Locale('zh'), .97),
  ;

  /// The locale of this localization.
  final Locale locale;

  /// The percentage of strings that are localized for this [locale].
  ///
  /// The value is a double contained between 0 and 1.
  final double percentage;

  /// The completion of the localization for the [locale] as a [percentage].
  const LocalizationCompletion(this.locale, this.percentage);

  /// Returns the percentage of strings that are localized for the [locale], formatted as a [String] for the [locale].
  static String getFormattedPercentage(Locale locale) {
    final percentage = values.firstWhere((localizationSupport) {
      return localizationSupport.locale == locale;
    }).percentage;

    return percentage.formatedAsPercentage(locale: locale);
  }
}
