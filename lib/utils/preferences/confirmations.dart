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

  String get title {
    switch (this) {
      case Confirmations.none:
        return localizations.confirmations_title_none;
      case Confirmations.irreversible:
        return localizations.confirmations_title_irreversible;
      case Confirmations.all:
        return localizations.confirmations_title_all;
      default:
        throw Exception();
    }
  }

  factory Confirmations.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.confirmations);

    return preference != null
        ? Confirmations.values.byName(preference)
        : PreferenceKey.confirmations.defaultValue as Confirmations;
  }
}
