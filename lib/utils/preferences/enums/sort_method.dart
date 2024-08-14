import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

/// Method to sort the notes in the notes list.
enum SortMethod {
  /// Sort according to their date.
  date,

  /// Sort according to their title.
  title,

  /// TODO: improve
  ascending,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory SortMethod.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.sortMethod);

    return preference != null
        ? SortMethod.values.byName(preference)
        : PreferenceKey.sortMethod.defaultValue as SortMethod;
  }
}
