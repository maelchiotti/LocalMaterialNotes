import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/add.dart';
import 'package:localmaterialnotes/l10n/app_localizations.g.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsManager {
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
        localizedTitle: AppLocalizations.of(context)!.action_add_note,
        icon: 'launcher_icon',
      ),
    ]);
  }
}
