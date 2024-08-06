import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

class LocaleUtils {
  Locale get deviceLocale {
    return Locale(Platform.localeName.split('_').first);
  }

  Locale get appLocale {
    final localePreferenceLanguageCode = PreferenceKey.locale.getPreferenceOrDefault<String>();

    return Locale(localePreferenceLanguageCode);
  }

  void setLocale(Locale locale) {
    PreferencesUtils().set(PreferenceKey.locale.name, locale.languageCode);
  }
}
