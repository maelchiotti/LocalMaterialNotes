import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

class LocaleManager {
  Locale get locale {
    final localePreferenceLanguageCode = PreferencesManager().get<String>(PreferenceKey.locale);

    if (localePreferenceLanguageCode != null) {
      return Locale(localePreferenceLanguageCode);
    } else {
      final deviceLocaleLanguage = Platform.localeName.split('_').first;
      for (final locale in AppLocalizations.supportedLocales) {
        if (deviceLocaleLanguage == locale.languageCode) {
          return locale;
        }
      }

      return Locale(PreferenceKey.locale.defaultValue as String);
    }
  }

  void setLocale(Locale? locale) {
    if (locale == null) {
      return;
    }

    PreferencesManager().set(PreferenceKey.locale.name, locale.languageCode);
  }
}
