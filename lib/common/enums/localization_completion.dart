import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';

/// Lists the localization completion for every supported language.
enum LocalizationCompletion {
  /// Czech.
  cs(Locale('cs'), 1),

  /// English.
  en(Locale('en'), 1),

  /// Spanish.
  es(Locale('es'), .97),

  /// French.
  fr(Locale('fr'), 1),

  /// German.
  de(Locale('de'), .97),

  /// Hindi.
  hi(Locale('hi'), .80),

  /// Italian.
  it(Locale('it'), .99),

  /// Polish.
  pl(Locale('pl'), .61),

  /// Portuguese.
  pt(Locale('pt'), .62),

  /// Russian.
  ru(Locale('ru'), .88),

  /// Turkish.
  tr(Locale('tr'), .80),

  /// Chinese Simplified.
  zh(Locale('zh'), 1),
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
