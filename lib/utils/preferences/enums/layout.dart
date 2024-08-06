import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

enum Layout {
  list,
  grid,
  ;

  factory Layout.fromPreference() {
    final preference = PreferencesUtils().get<String>(PreferenceKey.layout);

    return preference != null ? Layout.values.byName(preference) : PreferenceKey.layout.defaultValue as Layout;
  }
}
