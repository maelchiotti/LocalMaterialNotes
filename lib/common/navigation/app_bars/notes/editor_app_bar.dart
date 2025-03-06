import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../models/note/note_status.dart';
import '../../../../models/note/types/note_type.dart';
import '../../../../providers/notifiers/notifiers.dart';
import '../../../actions/notes/about.dart';
import '../../../actions/notes/archive.dart';
import '../../../actions/notes/copy.dart';
import '../../../actions/notes/delete.dart';
import '../../../actions/notes/labels.dart';
import '../../../actions/notes/lock.dart';
import '../../../actions/notes/pin.dart';
import '../../../actions/notes/restore.dart';
import '../../../actions/notes/share.dart';
import '../../../actions/notes/unarchive.dart';
import '../../../constants/constants.dart';
import '../../../constants/sizes.dart';
import '../../../preferences/preference_key.dart';
import '../../../system_utils.dart';
import '../../../widgets/placeholders/empty_placeholder.dart';
import '../../enums/editor/editor_archived_menu_option.dart';
import '../../enums/editor/editor_available_menu_option.dart';
import '../../enums/editor/editor_deleted_menu_option.dart';

/// Editor app bar.
class EditorAppBar extends ConsumerStatefulWidget {
  /// App bar of the editor page allowing to perform actions on the note.
  const EditorAppBar({super.key});

  @override
  ConsumerState<EditorAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends ConsumerState<EditorAppBar> {
  void switchMode() {
    isEditorInEditModeNotifier.value = !isEditorInEditModeNotifier.value;
  }

  /// Action to perform on the available [notes] depending on the selected [menuOption].
  Future<void> onAvailableMenuOptionSelected(EditorAvailableMenuOption menuOption) async {
    SystemUtils().closeKeyboard();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case EditorAvailableMenuOption.copy:
        await copyNote(note: note);
      case EditorAvailableMenuOption.share:
        await shareNote(note: note);
      case EditorAvailableMenuOption.pin:
      case EditorAvailableMenuOption.unpin:
        await togglePinNotes(context, ref, notes: [note]);
      case EditorAvailableMenuOption.lock:
      case EditorAvailableMenuOption.unlock:
        await toggleLockNotes(context, ref, notes: [note]);
      case EditorAvailableMenuOption.selectLabels:
        await selectLabels(context, ref, note: note);
      case EditorAvailableMenuOption.archive:
        await archiveNote(context, ref, note: note, pop: true);
      case EditorAvailableMenuOption.delete:
        await deleteNote(context, ref, note: note, pop: true);
      case EditorAvailableMenuOption.about:
        // Use the root navigator key to avoid popping to the lock screen
        await showAboutNote();
    }
  }

  /// Action to perform on the archived [notes] depending on the selected [menuOption].
  Future<void> onArchivedMenuOptionSelected(EditorArchivedMenuOption menuOption) async {
    SystemUtils().closeKeyboard();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case EditorArchivedMenuOption.copy:
        await copyNote(note: note);
      case EditorArchivedMenuOption.share:
        await shareNote(note: note);
      case EditorArchivedMenuOption.selectLabels:
        await selectLabels(context, ref, note: note);
      case EditorArchivedMenuOption.unarchive:
        await unarchiveNote(context, ref, note: note, pop: true);
      case EditorArchivedMenuOption.about:
        await showAboutNote();
    }
  }

  /// Action to perform on the deleted [notes] depending on the selected [menuOption].
  Future<void> onDeletedMenuOptionSelected(EditorDeletedMenuOption menuOption) async {
    SystemUtils().closeKeyboard();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case EditorDeletedMenuOption.restore:
        await restoreNote(context, ref, note: note, pop: true);
      case EditorDeletedMenuOption.deletePermanently:
        await permanentlyDeleteNote(context, ref, note: note, pop: true);
      case EditorDeletedMenuOption.about:
        await showAboutNote();
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

  @override
  Widget build(BuildContext context) {
    final note = currentNoteNotifier.value;

    if (note == null) {
      return EmptyPlaceholder();
    }

    final editorController = fleatherControllerNotifier.value;
    final showEditorModeButton = PreferenceKey.editorModeButton.preferenceOrDefault;
    final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;
    final lockNote = PreferenceKey.lockNote.preferenceOrDefault;

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
                        final enableUndo =
                            editorHasFocus &&
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
                      builder:
                          (context, isEditMode, child) => IconButton(
                            icon: Icon(isEditMode ? Icons.visibility : Icons.edit),
                            tooltip:
                                isEditMode
                                    ? l.tooltip_fab_toggle_editor_mode_read
                                    : l.tooltip_fab_toggle_editor_mode_edit,
                            onPressed: switchMode,
                          ),
                    ),
                  PopupMenuButton<EditorAvailableMenuOption>(
                    itemBuilder:
                        (context) => ([
                          EditorAvailableMenuOption.copy.popupMenuItem(context),
                          EditorAvailableMenuOption.share.popupMenuItem(context),
                          const PopupMenuDivider(),
                          if (note.pinned) EditorAvailableMenuOption.unpin.popupMenuItem(context),
                          if (!note.pinned) EditorAvailableMenuOption.pin.popupMenuItem(context),
                          if (lockNote && note.locked) EditorAvailableMenuOption.unlock.popupMenuItem(context),
                          if (lockNote && !note.locked) EditorAvailableMenuOption.lock.popupMenuItem(context),
                          if (enableLabels) EditorAvailableMenuOption.selectLabels.popupMenuItem(context),
                          const PopupMenuDivider(),
                          EditorAvailableMenuOption.archive.popupMenuItem(context),
                          EditorAvailableMenuOption.delete.popupMenuItem(context),
                          const PopupMenuDivider(),
                          EditorAvailableMenuOption.about.popupMenuItem(context),
                        ]),
                    onSelected: onAvailableMenuOptionSelected,
                  ),
                ],
                if (note.status == NoteStatus.archived)
                  PopupMenuButton<EditorArchivedMenuOption>(
                    itemBuilder:
                        (context) => ([
                          EditorArchivedMenuOption.copy.popupMenuItem(context),
                          EditorArchivedMenuOption.share.popupMenuItem(context),
                          const PopupMenuDivider(),
                          EditorArchivedMenuOption.unarchive.popupMenuItem(context),
                          const PopupMenuDivider(),
                          EditorArchivedMenuOption.about.popupMenuItem(context),
                        ]),
                    onSelected: onArchivedMenuOptionSelected,
                  ),
                if (note.status == NoteStatus.deleted)
                  PopupMenuButton<EditorDeletedMenuOption>(
                    itemBuilder:
                        (context) => ([
                          EditorDeletedMenuOption.restore.popupMenuItem(context),
                          EditorDeletedMenuOption.deletePermanently.popupMenuItem(context),
                          const PopupMenuDivider(),
                          EditorDeletedMenuOption.about.popupMenuItem(context),
                        ]),
                    onSelected: onDeletedMenuOptionSelected,
                  ),
                Gap(Sizes.appBarEnd.size),
              ],
            );
          },
        );
      },
    );
  }
}
