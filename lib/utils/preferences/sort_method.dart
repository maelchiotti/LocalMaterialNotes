import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

enum SortMethod {
  date('date'),
  title('title'),
  ascending('ascending'),
  ;

  final String name;

  const SortMethod(this.name);

  factory SortMethod.fromPreference() {
    final preference = PreferencesManager().get<String>(PreferenceKey.sortMethod);

    return preference != null
        ? SortMethod.values.byName(preference)
        : PreferenceKey.sortMethod.defaultValue as SortMethod;
  }
}
