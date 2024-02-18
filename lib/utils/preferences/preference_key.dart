import 'package:localmaterialnotes/utils/preferences/confirmations.dart';
import 'package:localmaterialnotes/utils/preferences/lock_latency.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

enum PreferenceKey {
  // Settings
  locale,
  theme,
  dynamicTheming(true),
  blackTheming(false),
  confirmations(Confirmations.irreversible),
  lock(false),
  lockLatency(LockLatency.five),

  // Notes
  sortMethod(SortMethod.date),
  sortAscending(false),
  ;

  final Object? defaultValue;

  const PreferenceKey([this.defaultValue]);
}
