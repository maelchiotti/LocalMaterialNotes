import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../pages/editor/sheets/about_sheet.dart';
import '../../../providers/notifiers/notifiers.dart';
import '../../actions/notes/copy.dart';
import '../../actions/notes/delete.dart';
import '../../actions/notes/labels.dart';
import '../../actions/notes/pin.dart';
import '../../actions/notes/restore.dart';
import '../../actions/notes/share.dart';
import '../../constants/constants.dart';
import '../../constants/paddings.dart';
import '../../preferences/preference_key.dart';
import '../enums/bin_menu_option.dart';
import '../enums/note_menu_option.dart';

/// Editor's app bar.
///
/// Contains:
///   - A back button.
///   - The title of the editor route.
///   - The undo/redo buttons if enabled by the user.
///   - The checklist button if enabled by the user.
///   - The menu with further actions.
class EditorAppBar extends ConsumerStatefulWidget {
  /// Default constructor.
  const EditorAppBar({
    super.key,
  });

  @override
  ConsumerState<EditorAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends ConsumerState<EditorAppBar> {
  /// Switches the editor mode between editing and viewing.
  void switchMode() {
    isEditorInEditModeNotifier.value = !isEditorInEditModeNotifier.value;
  }

  /// Performs the action associated with the selected [menuOption] on the not deleted note.
  Future<void> onNoteMenuOptionSelected(NoteMenuOption menuOption) async {
    // Manually close the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case NoteMenuOption.togglePin:
        await togglePinNote(context, ref, note: note);
      case NoteMenuOption.selectLabels:
        selectLabels(context, ref, note: note);
      case NoteMenuOption.copy:
        await copyNote(note: note);
      case NoteMenuOption.share:
        await shareNote(note: note);
      case NoteMenuOption.delete:
        await deleteNote(context, ref, note: note, pop: true);
      case NoteMenuOption.about:
        await showModalBottomSheet<void>(
          context: context,
          clipBehavior: Clip.hardEdge,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => const AboutSheet(),
        );
    }
  }

  /// Performs the action associated with the selected [menuOption] on the deleted note.
  Future<void> onBinMenuOptionSelected(BinMenuOption menuOption) async {
    // Manually close the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

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
        await showModalBottomSheet<void>(
          context: context,
          clipBehavior: Clip.hardEdge,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => const AboutSheet(),
        );
    }
  }

  /// Undoes the latest change in the editor.
  void undo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canUndo) {
      return;
    }

    editorController.undo();
  }

  /// Redoes the latest change in the editor.
  void redo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canRedo) {
      return;
    }

    editorController.redo();
  }

  /// Toggles the presence of the checklist in the currently active line of the editor.
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
    final editorController = fleatherControllerNotifier.value;

    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault();
    final showUndoRedoButtons = PreferenceKey.showUndoRedoButtons.getPreferenceOrDefault();
    final showChecklistButton = PreferenceKey.showChecklistButton.getPreferenceOrDefault();
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();

    return ValueListenableBuilder(
      valueListenable: editorHasFocusNotifier,
      builder: (context, editorHasFocus, child) => ValueListenableBuilder(
        valueListenable: isEditorInEditModeNotifier,
        builder: (context, isEditMode, child) => AppBar(
          leading: BackButton(),
          actions: note == null
              ? null
              : [
                  if (!note.deleted) ...[
                    if (showUndoRedoButtons)
                      ValueListenableBuilder(
                        valueListenable: fleatherControllerCanUndoNotifier,
                        builder: (context, canUndo, child) => IconButton(
                          icon: const Icon(Icons.undo),
                          tooltip: l.tooltip_undo,
                          onPressed: editorHasFocus &&
                                  canUndo &&
                                  editorController != null &&
                                  editorController.canUndo &&
                                  isEditMode
                              ? undo
                              : null,
                        ),
                      ),
                    if (showUndoRedoButtons)
                      ValueListenableBuilder(
                        valueListenable: fleatherControllerCanRedoNotifier,
                        builder: (context, canRedo, child) => IconButton(
                          icon: const Icon(Icons.redo),
                          tooltip: l.tooltip_redo,
                          onPressed: editorHasFocus && canRedo && isEditMode ? redo : null,
                        ),
                      ),
                    if (showChecklistButton)
                      IconButton(
                        icon: const Icon(Icons.checklist),
                        tooltip: l.tooltip_toggle_checkbox,
                        onPressed: editorHasFocus && isEditMode ? toggleChecklist : null,
                      ),
                    if (showEditorModeButton)
                      ValueListenableBuilder(
                        valueListenable: isEditorInEditModeNotifier,
                        builder: (context, isEditMode, child) => IconButton(
                          icon: Icon(isEditMode ? Icons.visibility : Icons.edit),
                          tooltip: isEditMode
                              ? l.tooltip_fab_toggle_editor_mode_read
                              : l.tooltip_fab_toggle_editor_mode_edit,
                          onPressed: switchMode,
                        ),
                      ),
                  ],
                  note.deleted
                      ? PopupMenuButton<BinMenuOption>(
                          itemBuilder: (context) => ([
                            BinMenuOption.restore.popupMenuItem(context),
                            BinMenuOption.deletePermanently.popupMenuItem(context),
                            const PopupMenuDivider(),
                            BinMenuOption.about.popupMenuItem(context),
                          ]),
                          onSelected: onBinMenuOptionSelected,
                        )
                      : PopupMenuButton<NoteMenuOption>(
                          itemBuilder: (context) => ([
                            NoteMenuOption.copy.popupMenuItem(context),
                            NoteMenuOption.share.popupMenuItem(context),
                            const PopupMenuDivider(),
                            NoteMenuOption.togglePin.popupMenuItem(context, alternative: note.pinned),
                            if (enableLabels) NoteMenuOption.selectLabels.popupMenuItem(context),
                            NoteMenuOption.delete.popupMenuItem(context),
                            const PopupMenuDivider(),
                            NoteMenuOption.about.popupMenuItem(context),
                          ]),
                          onSelected: onNoteMenuOptionSelected,
                        ),
                  Padding(padding: Paddings.appBarActionsEnd),
                ],
        ),
      ),
    );
  }
}
