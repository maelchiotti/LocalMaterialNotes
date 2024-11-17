import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/notes/add.dart';
import 'package:localmaterialnotes/utils/localizations_utils.dart';
import 'package:quick_actions/quick_actions.dart';

/// Utilities for the quick actions.
class QuickActionsUtils {
  /// Application's quick actions.
  late final QuickActions quickActions;

  /// Ensures the utility is initialized.
  void ensureInitialized(BuildContext context, WidgetRef ref) {
    quickActions = const QuickActions();

    quickActions.initialize((action) {
      if (action == 'add_note') {
        addNote(context, ref);
      }
    });

    quickActions.setShortcutItems([
      ShortcutItem(
        type: 'add_note',
        localizedTitle: LocalizationsUtils().actionAddNoteTitle,
        icon: 'ic_launcher',
      ),
    ]);
  }
}
