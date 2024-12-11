import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/localizations_utils.dart';

/// Utilities for the application's locale.
class LocaleUtils {
  /// Locale of the device.
  Locale get deviceLocale {
    return Locale(Platform.localeName.split('_').first);
  }

  /// Locale of the application.
  Locale get appLocale {
    final localePreferenceLanguageCode = PreferenceKey.locale.getPreferenceOrDefault();

    return Locale(localePreferenceLanguageCode);
  }

  /// Locale language code of the application.
  String get appLocaleLanguageCode {
    return appLocale.languageCode;
  }

  /// Sets the application's locale to [locale].
  Future<void> setLocale(Locale locale) async {
    await PreferenceKey.locale.set(locale.languageCode);

    // Reset the hardcoded localizations.
    await LocalizationsUtils().ensureInitialized();
  }
}
