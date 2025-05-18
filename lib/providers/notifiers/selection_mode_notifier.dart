import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import 'notifiers.dart';

/// Can pop notifier.
class CanPopNotifier extends ValueNotifier<bool> {
  /// Notifier for whether the routes can be popped.
  CanPopNotifier(super.value);

  /// Locks the page.
  void update() {
    final isNotesSelectionMode = isNotesSelectionModeNotifier.value;
    final isLabelsSelectionMode = isLabelsSelectionModeNotifier.value;

    final bool isDrawerOpen =
        (notesPageScaffoldKey.currentState?.isDrawerOpen ?? false) ||
        (labeledNotesPageScaffoldKey.currentState?.isDrawerOpen ?? false);
    final isAddNoteFabOpen =
        (addNoteFabKey.currentState?.isOpen ?? false) || (labeledAddNoteFabKey.currentState?.isOpen ?? false);

    final confirmBeforeExiting = PreferenceKey.confirmBeforeExiting.preferenceOrDefault;
    final mustConfirmToExit = confirmBeforeExiting ? mustConfirmToExitNotifier.value : true;

    value = !(isNotesSelectionMode || isLabelsSelectionMode || isDrawerOpen || isAddNoteFabOpen || !mustConfirmToExit);

    notifyListeners();
  }
}
