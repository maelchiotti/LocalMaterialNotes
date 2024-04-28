import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

enum Layout {
  list('list'),
  grid('grid'),
  ;

  final String name;

  const Layout(this.name);

  factory Layout.fromPreferences() {
    final layoutPreference = PreferencesManager().get<String>(PreferenceKey.layout);

    return layoutPreference != null
        ? Layout.values.byName(layoutPreference)
        : PreferenceKey.layout.defaultValue! as Layout;
  }
}
