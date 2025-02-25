import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_actions/quick_actions.dart';

import '../../l10n/app_localizations/app_localizations.g.dart';
import '../../models/note/types/note_type.dart';
import '../actions/notes/add.dart';

/// Utilities for the quick actions.
///
/// This class is a singleton.
class QuickActionsUtils {
  static final QuickActionsUtils _singleton = QuickActionsUtils._internal();

  /// Default constructor.
  factory QuickActionsUtils() => _singleton;

  QuickActionsUtils._internal();

  /// Application's quick actions.
  late final QuickActions quickActions;

  /// Ensures the utility is initialized.
  void ensureInitialized() {
    quickActions = const QuickActions();
  }

  /// Sets the quick actions.
  void setQuickActions(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final availableNotesTypes = NoteType.availableTypes;

    final addPlainTextNoteAction = ShortcutItem(
      type: 'add_plain_text_note',
      localizedTitle: l.quick_action_add_plain_text_note_title,
      icon: 'ic_text_fields',
    );
    final addMarkdownNoteAction = ShortcutItem(
      type: 'add_markdown_note',
      localizedTitle: l.quick_action_add_markdown_note_title,
      icon: 'ic_markdown',
    );
    final addRichTextNoteAction = ShortcutItem(
      type: 'add_rich_text_note',
      localizedTitle: l.quick_action_add_rich_text_note_title,
      icon: 'ic_format_paint',
    );
    final addChecklistNoteAction = ShortcutItem(
      type: 'add_checklist_note',
      localizedTitle: l.quick_action_add_checklist_note_title,
      icon: 'ic_checklist',
    );

    quickActions.initialize((action) {
      if (action == addPlainTextNoteAction.type) {
        addNote(context, ref, noteType: NoteType.plainText);
      } else if (action == addMarkdownNoteAction.type) {
        addNote(context, ref, noteType: NoteType.markdown);
      } else if (action == addRichTextNoteAction.type) {
        addNote(context, ref, noteType: NoteType.richText);
      } else if (action == addChecklistNoteAction.type) {
        addNote(context, ref, noteType: NoteType.checklist);
      }
    });

    quickActions.setShortcutItems([
      if (availableNotesTypes.contains(NoteType.plainText)) addPlainTextNoteAction,
      if (availableNotesTypes.contains(NoteType.markdown)) addMarkdownNoteAction,
      if (availableNotesTypes.contains(NoteType.richText)) addRichTextNoteAction,
      if (availableNotesTypes.contains(NoteType.checklist)) addChecklistNoteAction,
    ]);
  }
}
