import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_manager.dart';

enum LockLatency {
  zero(0),
  one(1),
  two(2),
  three(3),
  five(5),
  ten(10),
  thirty(30),
  oneHour(60),
  infinity(500000), // A bit less than a year
  ;

  final int minutes;

  const LockLatency(this.minutes);

  factory LockLatency.fromPreferences() {
    final confirmationPreference = PreferencesManager().get<String>(PreferenceKey.lockLatency);

    return confirmationPreference != null
        ? LockLatency.values.byName(confirmationPreference)
        : PreferenceKey.lockLatency.defaultValue! as LockLatency;
  }

  String get label {
    switch (this) {
      case LockLatency.zero:
        return localizations.lock_latency_immediately;
      case LockLatency.infinity:
        return localizations.lock_latency_never;
      default:
        return minutes.toString();
    }
  }
}
