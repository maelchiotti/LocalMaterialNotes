import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/localizations_utils.dart';

/// Utilities for the application's locale.
class LocaleUtils {
  /// Locale of the device.
  Locale get deviceLocale {
    return Locale(Platform.localeName.split('_').first);
  }

  /// Locale of the application.
  Locale get appLocale {
    final localePreferenceLanguageCode = PreferenceKey.locale.getPreferenceOrDefault<String>();

    return Locale(localePreferenceLanguageCode);
  }

  /// Sets the application's locale to [locale].
  Future<void> setLocale(Locale locale) async {
    await PreferencesUtils().set(PreferenceKey.locale, locale.languageCode);

    // Reset the hardcoded localizations.
    await LocalizationsUtils().ensureInitialized();
  }
}
