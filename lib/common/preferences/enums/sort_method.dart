import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// Sort method of the notes list.
enum SortMethod {
  /// Sort according to their creation date.
  createdDate,

  /// Sort according to their last edition date.
  editedDate,

  /// Sort according to their title.
  title,

  /// Sort in ascending order.
  ///
  /// This is only used to create the [PopupMenuItem] in the sort menu.
  ascending,
  ;

  /// Returns the value of the preference if set, or its default value otherwise.
  factory SortMethod.fromPreference() {
    final sortMethod = SortMethod.values.byNameOrNull(
      PreferenceKey.sortMethod.preference,
    );

    // Reset the malformed preference to its default value
    if (sortMethod == null) {
      PreferenceKey.sortMethod.reset();

      return SortMethod.values.byName(PreferenceKey.sortMethod.defaultValue);
    }

    return sortMethod;
  }

  /// Returns whether this sort method is based on a date.
  bool get onDate => [createdDate, editedDate].contains(this);
}
