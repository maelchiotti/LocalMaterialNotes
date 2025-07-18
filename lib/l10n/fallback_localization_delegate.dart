import 'package:flutter/material.dart';

/// Localization delegate with a fallback.
class FallbackLocalizationDelegate<T> extends LocalizationsDelegate<T> {
  /// The fallback locale.
  final Locale _fallbackLocale = Locale('en');

  /// The target locale.
  final LocalizationsDelegate<T> target;

  /// Localization delegate of the [target] locale that falls back to `en` if the localizations are not available.
  FallbackLocalizationDelegate({required this.target});

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<T> load(Locale locale) async {
    try {
      return await target.load(locale);
    } catch (e) {
      return await target.load(_fallbackLocale);
    }
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;
}
