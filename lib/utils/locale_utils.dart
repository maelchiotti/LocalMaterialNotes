import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

class LocaleUtils {
  Locale get deviceLocale {
    return Locale(Platform.localeName.split('_').first);
  }

  Locale get appLocale {
    final localePreferenceLanguageCode = PreferencesUtils().get<String>(PreferenceKey.locale);

    if (localePreferenceLanguageCode != null) {
      return Locale(localePreferenceLanguageCode);
    } else {
      return AppLocalizations.supportedLocales.contains(deviceLocale)
          ? deviceLocale
          : Locale(PreferenceKey.locale.defaultValue as String);
    }
  }

  void setLocale(Locale locale) {
    PreferencesUtils().set(PreferenceKey.locale.name, locale.languageCode);
  }
}
