import 'package:flag_secure/flag_secure.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';

/// Sets `FLAG_SECURE` to `true` if the corresponding preference was enabled by the user.
Future<void> setFlagSecureIfNeeded() async {
  if (PreferenceKey.flagSecure.getPreferenceOrDefault()) {
    await FlagSecure.set();
  }
}
