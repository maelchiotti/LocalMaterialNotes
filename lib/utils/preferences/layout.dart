import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

enum Layout {
  list('list'),
  grid('grid'),
  ;

  final String name;

  const Layout(this.name);

  factory Layout.fromPreference() {
    final preference = PreferencesManager().get<String>(PreferenceKey.layout);

    return preference != null ? Layout.values.byName(preference) : PreferenceKey.layout.defaultValue as Layout;
  }
}
