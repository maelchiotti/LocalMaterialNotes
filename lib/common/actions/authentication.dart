import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:restart_app/restart_app.dart';

import '../constants/constants.dart';
import '../extensions/build_context_extension.dart';
import '../preferences/preference_key.dart';
import '../ui/snack_bar_utils.dart';

/// Asks the user to authenticate for the specified [reason] using the device lock method.
Future<bool> authenticate(BuildContext context, {required String reason}) async {
  final localAuthentication = LocalAuthentication();

  final canAuthenticate = await localAuthentication.isDeviceSupported();

  // If the device has no authentication methods available,
  // disable the app lock and restart it to remove the lock screen
  if (!canAuthenticate) {
    await PreferenceKey.lockApp.set(false);

    // The Restart package crashes the app if used in debug mode
    if (kReleaseMode) {
      await Restart.restartApp();
    }

    return false;
  }

  bool authenticated;
  try {
    authenticated = await localAuthentication.authenticate(localizedReason: reason);
  } on LocalAuthException catch (exception) {
    if (exception.code != LocalAuthExceptionCode.userCanceled) {
      logger.w("Authentication failed", exception);
    }

    authenticated = false;
  }

  // The authentication failed
  if (!authenticated) {
    if (!context.mounted) {
      return false;
    }

    SnackBarUtils().show(context, text: context.l.snack_bar_authentication_failed);

    return false;
  }

  return true;
}
