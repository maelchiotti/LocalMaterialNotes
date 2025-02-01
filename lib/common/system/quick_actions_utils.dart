import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../models/note/note.dart';
import '../../models/note/notes_types.dart';
import '../actions/notes/add.dart';
import '../localization/localizations_utils.dart';

/// Utilities for the quick actions.
class QuickActionsUtils {
  /// Application's quick actions.
  late final QuickActions quickActions;

  /// Ensures the utility is initialized.
  void ensureInitialized(BuildContext context, WidgetRef ref) {
    quickActions = const QuickActions();

    quickActions.initialize((action) {
      if (action == 'add_note') {
        final defaultShortcutNoteType = NoteType.defaultShortcutType;

        switch (defaultShortcutNoteType) {
          case NoteType.plainText:
            addNote<PlainTextNote>(context, ref);
          case NoteType.richText:
            addNote<RichTextNote>(context, ref);
        }
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
