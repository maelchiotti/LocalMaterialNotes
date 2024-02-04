import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

enum Confirmations {
  none('none'),
  irreversible('irreversible'),
  all('all'),
  ;

  final String name;

  const Confirmations(this.name);

  factory Confirmations.fromPreferences() {
    final method = PreferencesManager().get<String>(PreferenceKey.confirmations) ??
        PreferenceKey.confirmations.defaultValue! as String;

    if (method == Confirmations.none.name) {
      return Confirmations.none;
    } else if (method == Confirmations.irreversible.name) {
      return Confirmations.irreversible;
    } else if (method == Confirmations.all.name) {
      return Confirmations.all;
    } else {
      return Confirmations.irreversible;
    }
  }

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

  String get description {
    switch (this) {
      case Confirmations.none:
        return localizations.confirmations_description_none;
      case Confirmations.irreversible:
        return localizations.confirmations_description_irreversible;
      case Confirmations.all:
        return localizations.confirmations_description_all;
      default:
        throw Exception();
    }
  }
}
