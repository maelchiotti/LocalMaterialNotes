import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note_status.dart';
import '../../../models/note/types/note_type.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../actions/notes/about.dart';
import '../../actions/notes/archive.dart';
import '../../actions/notes/copy.dart';
import '../../actions/notes/delete.dart';
import '../../actions/notes/labels.dart';
import '../../actions/notes/pin.dart';
import '../../actions/notes/restore.dart';
import '../../actions/notes/share.dart';
import '../../actions/notes/unarchive.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../preferences/preference_key.dart';
import '../../utils.dart';
import '../../widgets/placeholders/empty_placeholder.dart';
import '../enums/archives_menu_option.dart';
import '../enums/bin_menu_option.dart';
import '../enums/editor_menu_option.dart';

/// Editor app bar.
class EditorAppBar extends ConsumerStatefulWidget {
  /// App bar of the editor page allowing to perform actions on the note.
  const EditorAppBar({
    super.key,
  });

  @override
  ConsumerState<EditorAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends ConsumerState<EditorAppBar> {
  void switchMode() {
    isEditorInEditModeNotifier.value = !isEditorInEditModeNotifier.value;
  }

  /// Action to perform on the available [notes] depending on the selected [menuOption].
  Future<void> onNoteMenuOptionSelected(EditorMenuOption menuOption) async {
    closeKeyboard();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case EditorMenuOption.togglePin:
        await togglePinNote(context, ref, note: note);
      case EditorMenuOption.selectLabels:
        selectLabels(context, ref, note: note);
      case EditorMenuOption.copy:
        await copyNote(note: note);
      case EditorMenuOption.share:
        await shareNote(note: note);
      case EditorMenuOption.archive:
        await archiveNote(context, ref, note: note);
      case EditorMenuOption.delete:
        await deleteNote(context, ref, note: note, pop: true);
      case EditorMenuOption.about:
        await showNoteAbout(context);
    }
  }

  /// Action to perform on the archived [notes] depending on the selected [menuOption].
  Future<void> onArchivesMenuOptionSelected(ArchivesMenuOption menuOption) async {
    closeKeyboard();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case ArchivesMenuOption.unarchive:
        await unarchiveNote(context, ref, note: note, pop: true);
      case ArchivesMenuOption.about:
        await showNoteAbout(context);
    }
  }

  /// Action to perform on the deleted [notes] depending on the selected [menuOption].
  Future<void> onBinMenuOptionSelected(BinMenuOption menuOption) async {
    closeKeyboard();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case BinMenuOption.restore:
        await restoreNote(context, ref, note: note, pop: true);
      case BinMenuOption.deletePermanently:
        await permanentlyDeleteNote(context, ref, note: note, pop: true);
      case BinMenuOption.about:
        await showNoteAbout(context);
    }
  }

  /// Undo the last action in the rich text editor.
  void undo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canUndo) {
      return;
    }

    editorController.undo();
  }

  /// Redo the last action in the rich text editor.
  void redo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canRedo) {
      return;
    }

    editorController.redo();
  }

  /// Toggle whether a checklist is present at the current line in the rich text editor.
  void toggleChecklist() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null) {
      return;
    }

    final isToggled = editorController.getSelectionStyle().containsSame(ParchmentAttribute.block.checkList);
    editorController.formatSelection(
      isToggled ? ParchmentAttribute.block.checkList.unset : ParchmentAttribute.block.checkList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final note = currentNoteNotifier.value;

    if (note == null) {
      return EmptyPlaceholder();
    }

    final editorController = fleatherControllerNotifier.value;
    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault();
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();

    return ValueListenableBuilder(
      valueListenable: editorHasFocusNotifier,
      builder: (context, editorHasFocus, child) {
        return ValueListenableBuilder(
          valueListenable: isEditorInEditModeNotifier,
          builder: (context, isEditMode, child) {
            return AppBar(
              leading: BackButton(),
              actions: [
                if (note.status == NoteStatus.available) ...[
                  if (note.type == NoteType.richText) ...[
                    ValueListenableBuilder(
                      valueListenable: fleatherControllerCanUndoNotifier,
                      builder: (context, canUndo, child) {
                        final enableUndo = editorHasFocus &&
                            canUndo &&
                            editorController != null &&
                            editorController.canUndo &&
                            isEditMode;

                        return IconButton(
                          icon: const Icon(Icons.undo),
                          tooltip: l.tooltip_undo,
                          onPressed: enableUndo ? undo : null,
                        );
                      },
                    ),
                    ValueListenableBuilder(
                      valueListenable: fleatherControllerCanRedoNotifier,
                      builder: (context, canRedo, child) {
                        final enableRedo = editorHasFocus && canRedo && isEditMode;

                        return IconButton(
                          icon: const Icon(Icons.redo),
                          tooltip: l.tooltip_redo,
                          onPressed: enableRedo ? redo : null,
                        );
                      },
                    ),
                  ],
                  if (showEditorModeButton)
                    ValueListenableBuilder(
                      valueListenable: isEditorInEditModeNotifier,
                      builder: (context, isEditMode, child) => IconButton(
                        icon: Icon(isEditMode ? Icons.visibility : Icons.edit),
                        tooltip:
                            isEditMode ? l.tooltip_fab_toggle_editor_mode_read : l.tooltip_fab_toggle_editor_mode_edit,
                        onPressed: switchMode,
                      ),
                    ),
                  PopupMenuButton<EditorMenuOption>(
                    itemBuilder: (context) => ([
                      EditorMenuOption.copy.popupMenuItem(context),
                      EditorMenuOption.share.popupMenuItem(context),
                      const PopupMenuDivider(),
                      EditorMenuOption.togglePin.popupMenuItem(context, alternative: note.pinned),
                      if (enableLabels) EditorMenuOption.selectLabels.popupMenuItem(context),
                      const PopupMenuDivider(),
                      EditorMenuOption.archive.popupMenuItem(context),
                      EditorMenuOption.delete.popupMenuItem(context),
                      const PopupMenuDivider(),
                      EditorMenuOption.about.popupMenuItem(context),
                    ]),
                    onSelected: onNoteMenuOptionSelected,
                  ),
                ],
                if (note.status == NoteStatus.archived)
                  PopupMenuButton<ArchivesMenuOption>(
                    itemBuilder: (context) => ([
                      ArchivesMenuOption.unarchive.popupMenuItem(context),
                      const PopupMenuDivider(),
                      ArchivesMenuOption.about.popupMenuItem(context),
                    ]),
                    onSelected: onArchivesMenuOptionSelected,
                  ),
                if (note.status == NoteStatus.deleted)
                  PopupMenuButton<BinMenuOption>(
                    itemBuilder: (context) => ([
                      BinMenuOption.restore.popupMenuItem(context),
                      BinMenuOption.deletePermanently.popupMenuItem(context),
                      const PopupMenuDivider(),
                      BinMenuOption.about.popupMenuItem(context),
                    ]),
                    onSelected: onBinMenuOptionSelected,
                  ),
                Padding(padding: Paddings.appBarActionsEnd),
              ],
            );
          },
        );
      },
    );
  }
}
