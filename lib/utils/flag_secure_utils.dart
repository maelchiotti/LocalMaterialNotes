import 'package:flag_secure/flag_secure.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';

/// Sets `FLAG_SECURE` to `true` if the corresponding preference was enabled by the user.
Future<void> setFlagSecureIfNeeded() async {
  if (PreferenceKey.flagSecure.getPreferenceOrDefault<bool>()) {
    await FlagSecure.set();
  }
}
