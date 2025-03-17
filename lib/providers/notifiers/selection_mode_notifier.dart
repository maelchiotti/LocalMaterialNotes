import 'package:flutter/material.dart';

import '../../common/constants/constants.dart';
import 'notifiers.dart';

/// Can pop notifier.
class CanPopNotifier extends ValueNotifier<bool> {
  /// Notifier for whether the routes can be popped.
  CanPopNotifier(super.value);

  /// Locks the page.
  void update() {
    final isNotesSelectionMode = isNotesSelectionModeNotifier.value;
    final isLabelsSelectionMode = isLabelsSelectionModeNotifier.value;

    final isAddNoteFabOpen = addNoteFabKey.currentState?.isOpen ?? false;
    final bool isDrawerOpen = notesPageScaffoldKey.currentState?.isDrawerOpen ?? false;

    value = !(isNotesSelectionMode || isLabelsSelectionMode || isDrawerOpen || isAddNoteFabOpen);

    notifyListeners();
  }
}
