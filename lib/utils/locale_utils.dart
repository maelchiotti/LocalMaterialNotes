import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';

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
  void setLocale(Locale locale) {
    PreferencesUtils().set(PreferenceKey.locale.name, locale.languageCode);
  }
}
