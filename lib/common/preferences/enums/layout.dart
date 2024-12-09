import 'package:localmaterialnotes/common/extensions/iterable_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';

/// Layout of the notes list.
enum Layout {
  /// List view.
  list,

  /// Grid view.
  grid,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Layout.fromPreference() {
    final layout = Layout.values.byNameOrNull(
      PreferenceKey.layout.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (layout == null) {
      PreferenceKey.layout.reset();

      return Layout.values.byName(PreferenceKey.layout.defaultValue);
    }

    return layout;
  }
}
