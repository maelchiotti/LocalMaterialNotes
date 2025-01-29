import '../../l10n/app_localizations/app_localizations.g.dart';
import 'locale_utils.dart';

/// Utilities for the hardcoded application's localizations.
///
/// This class is a singleton.
class LocalizationsUtils {
  static final LocalizationsUtils _singleton = LocalizationsUtils._internal();

  /// Default constructor.
  factory LocalizationsUtils() => _singleton;

  LocalizationsUtils._internal();

  late AppLocalizations _appLocalizations;

  /// Returns the application's localizations corresponding to the current locale.
  Future<void> ensureInitialized() async {
    _appLocalizations = await AppLocalizations.delegate.load(LocaleUtils().appLocale);
  }

  /// Title of the quick action to add a note.
  String get actionAddNoteTitle => _appLocalizations.action_add_note_title;

  /// Title of the welcome note.
  String get welcomeNoteTitle => _appLocalizations.welcome_note_title;

  /// Content of the welcome note.
  String get welcomeNoteContent => _appLocalizations.welcome_note_content;
}
