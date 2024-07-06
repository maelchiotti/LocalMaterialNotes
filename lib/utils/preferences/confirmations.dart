import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

enum Confirmations {
  none('none'),
  irreversible('irreversible'),
  all('all'),
  ;

  final String name;

  const Confirmations(this.name);

  factory Confirmations.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.confirmations);

    return preference != null
        ? Confirmations.values.byName(preference)
        : PreferenceKey.confirmations.defaultValue as Confirmations;
  }

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
