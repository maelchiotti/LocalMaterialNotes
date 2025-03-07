import 'package:flutter/material.dart';

/// Page lock notifier.
class LockNotifier extends ValueNotifier<bool> {
  /// Notifier to lock a page.
  LockNotifier(super.value);

  /// Locks the page.
  void lock() {
    value = true;

    notifyListeners();
  }

  /// Unlocks the page.
  void unlock() {
    value = false;

    notifyListeners();
  }
}
