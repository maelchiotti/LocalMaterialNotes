import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/add.dart';
import 'package:localmaterialnotes/l10n/hardcoded_localizations.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsUtils {
  late final QuickActions quickActions;

  void init(BuildContext context, WidgetRef ref) {
    quickActions = const QuickActions();

    quickActions.initialize((action) {
      if (action == 'add_note') {
        addNote(context, ref);
      }
    });

    quickActions.setShortcutItems([
      ShortcutItem(
        type: 'add_note',
        localizedTitle: actionAddNoteTitle,
        icon: 'ic_launcher',
      ),
    ]);
  }
}
