import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_en.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_es.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_fr.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_pt.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_ru.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_tr.g.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';

/// Utilities for the hardcoded application's localizations.
class HardcodedLocalizationsUtils {
  /// Lists all the available application's localizations.
  final _appLocalizationsList = [
    AppLocalizationsEn(),
    AppLocalizationsEs(),
    AppLocalizationsFr(),
    AppLocalizationsPt(),
    AppLocalizationsRu(),
    AppLocalizationsTr(),
  ];

  /// Returns the application's localizations corresponding to the current locale.
  AppLocalizations get _appLocalizations {
    final currentLanguageCode = LocaleUtils().appLocale.languageCode;

    return _appLocalizationsList.firstWhere((appLocalizations) {
      return appLocalizations.localeName == currentLanguageCode;
    });
  }

  /// Title of the quick action to add a note.
  String get actionAddNoteTitle => _appLocalizations.action_add_note_title;

  /// Title of the welcome note.
  String get welcomeNoteTitle => _appLocalizations.welcome_note_title;

  /// Content of the welcome note.
  String get welcomeNoteContent => _appLocalizations.welcome_note_content;
}
