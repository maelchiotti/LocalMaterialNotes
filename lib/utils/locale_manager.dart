import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

class LocaleManager {
  Locale get locale {
    final preferredLocaleLanguageCode = PreferencesManager().get<String>(PreferenceKey.locale);

    if (preferredLocaleLanguageCode != null) {
      return Locale(preferredLocaleLanguageCode);
    } else {
      if (kIsWeb) return const Locale('en');

      final deviceLocale = Platform.localeName;
      for (final locale in AppLocalizations.supportedLocales) {
        if (deviceLocale.split('_').first == locale.languageCode) {
          return locale;
        }
      }

      return const Locale('en');
    }
  }

  void setLocale(Locale? locale) {
    if (locale == null) return;

    PreferencesManager().set(PreferenceKey.locale.name, locale.languageCode);

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(localizations.settings_language_restart),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
