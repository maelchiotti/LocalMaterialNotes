import 'package:localmaterialnotes/utils/preferences/enums/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/enums/layout.dart';
import 'package:localmaterialnotes/utils/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/utils/preferences/enums/swipe_action.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

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
  confirmations(Confirmations.irreversible),
  swipeRightAction(SwipeAction.delete),
  swipeLeftAction(SwipeAction.pin),
  flagSecure(false),
  showSeparators(false),
  showTilesBackground(false),

  // Backup
  autoExportFrequency(0.0),
  autoExportEncryption(false),
  autoExportPassword(''),
  lastAutoExportDate(''),

  // Notes
  sortMethod(SortMethod.date),
  sortAscending(false),
  layout(Layout.list),
  ;

  final Object defaultValue;

  const PreferenceKey(this.defaultValue);

  T getPreferenceOrDefault<T>() {
    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    if (T != bool && T != int && T != double && T != String && T != List<String>) {
      throw ArgumentError('The type T should be a native type (bool, int, double, String or List<String>), not $T.');
    }

    return PreferencesUtils().get<T>(this) ?? defaultValue as T;
  }

  Future<String> getPreferenceOrDefaultSecure() async {
    return await PreferencesUtils().getSecure(this) ?? defaultValue as String;
  }
}
