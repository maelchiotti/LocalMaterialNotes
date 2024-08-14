import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

/// Lists the layouts of the notes list.
enum Layout {
  /// List view.
  list,

  /// Grid view.
  grid,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Layout.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.layout);

    return preference != null ? Layout.values.byName(preference) : PreferenceKey.layout.defaultValue as Layout;
  }
}
