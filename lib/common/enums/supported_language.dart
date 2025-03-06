import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:locale_names/locale_names.dart';

/// Languages supported by the application.
enum SupportedLanguage {
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

  /// Chinese Traditional.
  zhTW(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'), 0);

  /// The locale completion of this language.
  final Locale locale;

  /// The translation completion of this language.
  final num completion;

  /// A language supported by the application with its [locale] and its translation [completion].
  const SupportedLanguage(this.locale, this.completion);

  /// Returns the list of [locale] supported by the application.
  static List<Locale> locales = values.map((language) => language.locale).toList();

  /// Returns the native name of this language.
  String get nativeName => locale.nativeDisplayLanguage.capitalizeFirstLetter;

  /// Returns the translation completion of this language formatted as a percentage according to the [locale].
  String get completionFormatted => completion.formatAsPercentage(locale: locale.languageCode);
}
