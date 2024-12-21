import '../../common/preferences/watched_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preferences_provider.g.dart';

/// Provider for the preferences.
@Riverpod(keepAlive: true)
class Preferences extends _$Preferences {
  @override
  WatchedPreferences build() {
    return WatchedPreferences();
  }

  /// Updates the watched preferences with the new [preferences].
  void update(WatchedPreferences preferences) {
    state = preferences;
  }

  /// Resets the watched preferences to their default values.
  void reset() {
    state = WatchedPreferences();
  }
}
