import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';

// ignore_for_file: public_member_api_docs

/// Lists the localization completion for every supported language.
enum LocalizationCompletion {
  /// English.
  en(Locale('en'), 1),

  /// Spanish.
  es(Locale('es'), .87),

  /// French.
  fr(Locale('fr'), 1),

  /// German.
  de(Locale('de'), 1),

  /// Hindi.
  hi(Locale('hi'), .87),

  /// Polish.
  pl(Locale('pl'), .75),

  /// Portuguese.
  pt(Locale('pt'), .75),

  /// Russian.
  ru(Locale('ru'), .87),

  /// Turkish.
  tr(Locale('tr'), .78),

  /// Chinese Simplified.
  zh(Locale('zh'), .87),
  ;

  /// The locale of this localization.
  final Locale locale;

  /// The percentage of strings that are localized for this [locale].
  ///
  /// The value is a double contained between 0 and 1.
  final num percentage;

  /// The completion of the localization for the [locale] as a [percentage].
  const LocalizationCompletion(this.locale, this.percentage);

  /// Returns the percentage of strings that are localized for the [locale], formatted as a [String] for the [locale].
  static String getFormattedPercentage(Locale locale) {
    final percentage = values.firstWhere((localizationSupport) => localizationSupport.locale == locale).percentage;

    return percentage.formatAsPercentage(locale: locale.languageCode);
  }
}
