import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

enum PreferenceKey {
  // Settings
  locale,
  theme,
  dynamicTheming(true),
  blackTheming(false),
  separator(false),
  confirmations(Confirmations.irreversible),

  // Notes
  sortMethod(SortMethod.date),
  sortAscending(false),
  ;

  final Object? defaultValue;

  const PreferenceKey([this.defaultValue]);
}
