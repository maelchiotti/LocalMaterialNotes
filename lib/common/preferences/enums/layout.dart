import 'package:localmaterialnotes/common/extensions/iterable_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';

/// Lists the layouts of the notes list.
enum Layout {
  /// List view.
  list,

  /// Grid view.
  grid,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Layout.fromPreference() {
    final layout = Layout.values.byNameOrNull(
      PreferenceKey.layout.getPreference<String>(),
    );

    // Reset the malformed preference to its default value
    if (layout == null) {
      PreferenceKey.layout.setToDefault();

      return PreferenceKey.layout.defaultValue as Layout;
    }

    return layout;
  }
}
