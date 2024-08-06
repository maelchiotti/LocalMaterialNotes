import 'package:localmaterialnotes/l10n/app_localizations/app_localizations.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_en.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_es.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_fr.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_ru.g.dart';
import 'package:localmaterialnotes/l10n/app_localizations/app_localizations_tr.g.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';

class HardcodedLocalizationsUtils {
  final _appLocalizationsList = [
    AppLocalizationsEn(),
    AppLocalizationsEs(),
    AppLocalizationsFr(),
    AppLocalizationsRu(),
    AppLocalizationsTr(),
  ];

  AppLocalizations get _appLocalizations {
    return _appLocalizationsList.firstWhere((appLocalizations) {
      return appLocalizations.localeName == LocaleUtils().appLocale.languageCode;
    });
  }

  String get actionAddNoteTitle => _appLocalizations.action_add_note_title;

  String get welcomeNoteTitle => _appLocalizations.welcome_note_title;

  String get welcomeNoteContent => _appLocalizations.welcome_note_content;
}
