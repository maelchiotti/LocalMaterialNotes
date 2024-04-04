import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/add.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';
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
        localizedTitle: _actionAddNoteTitle,
        icon: 'launcher_icon',
      ),
    ]);
  }

  /// Hardcode the action title translations here because no context is available when it's used
  String get _actionAddNoteTitle {
    final locale = LocaleManager().locale;

    final String title;

    if (locale == const Locale('en')) {
      title = 'Add a note';
    } else if (locale == const Locale('fr')) {
      title = 'Ajouter une note';
    } else {
      throw Exception('Missing title of add note action for locale: $locale');
    }

    return title;
  }
}
