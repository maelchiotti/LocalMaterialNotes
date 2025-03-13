import '../../constants/constants.dart';
import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// Rich text editor toolbar style.
enum ToolbarStyle {
  /// One row with only simple formatting options.
  oneRowSimple,

  /// One row with all formatting options.
  oneRowAll,

  /// Two rows stacked one above the other.
  twoRowsStacked,

  /// Two rows with a button to toggle between them.
  twoRowsToggleable;

  /// The value of the preference if set, or its default value otherwise.
  factory ToolbarStyle.fromPreference() {
    final toolbarStyle = ToolbarStyle.values.byNameOrNull(PreferenceKey.toolbarStyle.preference);

    // Reset the malformed preference to its default value
    if (toolbarStyle == null) {
      PreferenceKey.toolbarStyle.reset();

      return ToolbarStyle.values.byName(PreferenceKey.toolbarStyle.defaultValue);
    }

    return toolbarStyle;
  }

  /// The title of the preference for the settings page.
  String get title {
    return switch (this) {
      oneRowSimple => l.toolbar_style_one_row_simple_title,
      oneRowAll => l.toolbar_style_one_row_all_title,
      twoRowsStacked => l.toolbar_style_two_rows_stacked_title,
      twoRowsToggleable => l.toolbar_style_two_rows_toggleable_title,
    };
  }

  /// The description of the preference for the settings page.
  String get description {
    return switch (this) {
      oneRowSimple => l.toolbar_style_one_row_simple_description,
      oneRowAll => l.toolbar_style_one_row_all_description,
      twoRowsStacked => l.toolbar_style_two_rows_stacked_description,
      twoRowsToggleable => l.toolbar_style_two_rows_toggleable_description,
    };
  }
}
