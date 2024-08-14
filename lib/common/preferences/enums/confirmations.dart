import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';

/// Lists the options for the confirmations asked for user actions such as pining and deleting notes.
enum Confirmations {
  /// Never ask for a confirmation.
  none,

  /// Asks confirmations only for irreversible actions.
  irreversible,

  /// Always ask for a confirmation.
  all,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Confirmations.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.confirmations);

    return preference != null
        ? Confirmations.values.byName(preference)
        : PreferenceKey.confirmations.defaultValue as Confirmations;
  }

  /// Returns the title of the preference for the settings page.
  String get title {
    switch (this) {
      case none:
        return localizations.confirmations_title_none;
      case irreversible:
        return localizations.confirmations_title_irreversible;
      case all:
        return localizations.confirmations_title_all;
    }
  }
}
