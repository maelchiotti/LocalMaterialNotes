import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/layout.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

enum PreferenceKey {
  // Appearance
  locale,
  theme,
  dynamicTheming(true),
  blackTheming(false),

  // Behavior
  separator(false),
  confirmations(Confirmations.irreversible),

  // Notes
  sortMethod(SortMethod.date),
  sortAscending(false),
  layout(Layout.list),
  ;

  final Object? defaultValue;

  const PreferenceKey([this.defaultValue]);
}
