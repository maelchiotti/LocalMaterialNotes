import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

enum SortMethod {
  date('date'),
  title('title'),
  ascending('ascending'),
  ;

  final String name;

  const SortMethod(this.name);

  factory SortMethod.methodFromPreferences() {
    final methodPreference = PreferencesManager().get<String>(PreferenceKey.sortMethod);

    return methodPreference != null
        ? SortMethod.values.byName(methodPreference)
        : PreferenceKey.sortMethod.defaultValue! as SortMethod;
  }

  static bool get ascendingFromPreferences {
    final ascendingPreference = PreferencesManager().get<bool>(PreferenceKey.sortAscending);

    return ascendingPreference ?? PreferenceKey.sortAscending.defaultValue! as bool;
  }
}
