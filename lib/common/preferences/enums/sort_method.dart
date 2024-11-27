import 'package:localmaterialnotes/common/extensions/iterable_extension.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';

/// Lists the methods to sort the notes in the notes list.
enum SortMethod {
  /// Sort according to their creation date.
  createdDate,

  /// Sort according to their last edition date.
  editedDate,

  /// Sort according to their title.
  title,

  /// Sort in ascending order.
  ///
  /// This is only used to create the `PopupMenuItem` in the sort menu.
  ascending,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory SortMethod.fromPreference() {
    final sortMethod = SortMethod.values.byNameOrNull(
      PreferenceKey.sortMethod.getPreference<String>(),
    );

    // Reset the malformed preference to its default value
    if (sortMethod == null) {
      PreferenceKey.sortMethod.setToDefault();

      return PreferenceKey.sortMethod.defaultValue as SortMethod;
    }

    return sortMethod;
  }

  /// Returns whether this sort method is based on a date.
  bool get onDate {
    return [createdDate, editedDate].contains(this);
  }
}
