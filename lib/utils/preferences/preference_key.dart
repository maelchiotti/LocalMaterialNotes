import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

enum PreferenceKey {
  // Appearance
  locale('en'),
  theme(0),
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

  final Object defaultValue;

  const PreferenceKey(this.defaultValue);

  T getPreferenceOrDefault<T>() {
    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    return PreferencesManager().get<T>(this) ?? defaultValue as T;
  }
}
