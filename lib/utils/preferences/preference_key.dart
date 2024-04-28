import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

enum PreferenceKey {
  // Appearance
  locale,
  theme,
  dynamicTheming(true),
  blackTheming(false),

  // Editor
  showUndoRedoButtons(true),
  showChecklistButton(true),
  showToolbar(true),

  // Behavior
  showSeparators(false),
  confirmations(Confirmations.irreversible),

  // Notes
  sortMethod(SortMethod.date),
  sortAscending(false),
  ;

  final Object? defaultValue;

  const PreferenceKey([this.defaultValue]);
}
