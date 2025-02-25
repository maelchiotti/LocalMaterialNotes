import 'dart:io';

import 'package:flutter/material.dart';

import '../preferences/preference_key.dart';
import 'localizations_utils.dart';

/// Utilities for the application's locale.
class LocaleUtils {
  /// Locale of the device.
  Locale get deviceLocale {
    final localeCodes = Platform.localeName.split('-');
    final languageCode = localeCodes.first;
    String? countryCode;
    if (localeCodes.length == 2) {
      countryCode = localeCodes[1];
    }

    return Locale.fromSubtags(languageCode: languageCode, countryCode: countryCode);
  }

  /// Locale of the application.
  Locale get appLocale {
    final localeCodes = PreferenceKey.locale.preferenceOrDefault.split('-');
    final languageCode = localeCodes.first;
    String? scriptCode;
    if (localeCodes.length == 2) {
      scriptCode = localeCodes[1];
    }
    String? countryCode;
    if (localeCodes.length == 3) {
      countryCode = localeCodes[2];
    }

    return Locale.fromSubtags(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
  }

  /// Locale language code of the application.
  String get appLocaleLanguageCode => appLocale.languageCode;

  /// Sets the application's locale to [locale].
  Future<void> setLocale(Locale locale) async {
    await PreferenceKey.locale.set(locale.toLanguageTag());

    // Reset the hardcoded localizations
    await LocalizationsUtils().ensureInitialized();
  }
}
