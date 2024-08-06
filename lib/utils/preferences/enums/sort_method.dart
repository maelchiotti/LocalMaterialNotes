import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

enum SortMethod {
  date,
  title,
  ascending,
  ;

  factory SortMethod.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.sortMethod);

    return preference != null
        ? SortMethod.values.byName(preference)
        : PreferenceKey.sortMethod.defaultValue as SortMethod;
  }
}
