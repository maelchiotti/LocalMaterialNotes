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
    final method =
        PreferencesManager().get<String>(PreferenceKey.sortMethod) ?? PreferenceKey.sortMethod.defaultValue! as String;

    if (method == SortMethod.date.name) {
      return SortMethod.date;
    } else if (method == SortMethod.title.name) {
      return SortMethod.title;
    } else {
      return SortMethod.date;
    }
  }

  static bool get ascendingFromPreferences {
    return PreferencesManager().get<bool>(PreferenceKey.sortAscending) ??
        PreferenceKey.sortAscending.defaultValue! as bool;
  }
}
