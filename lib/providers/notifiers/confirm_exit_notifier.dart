import 'package:flutter/material.dart';

import 'notifiers.dart';

/// Confirm exit notifier.
class ConfirmExitNotifier extends ValueNotifier<bool> {
  /// Notifier for whether the user must confirm to exit the application.
  ConfirmExitNotifier(super.value);

  /// Requires the users to confirm within 4 seconds.
  void confirm() {
    value = true;

    Future.delayed(Duration(seconds: 4), () {
      reset();

      canPopNotifier.update();
    });

    notifyListeners();
  }

  /// Resets the notifier.
  void reset() {
    value = false;

    notifyListeners();
  }
}
