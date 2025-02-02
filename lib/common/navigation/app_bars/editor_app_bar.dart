import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/notes_types.dart';
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

  void undo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canUndo) {
      return;
    }

    editorController.undo();
  }

  void redo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canRedo) {
      return;
    }

    editorController.redo();
  }

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
                    if (note.type == NoteType.richText) ...[
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
                      ValueListenableBuilder(
                        valueListenable: fleatherControllerCanRedoNotifier,
                        builder: (context, canRedo, child) => IconButton(
                          icon: const Icon(Icons.redo),
                          tooltip: l.tooltip_redo,
                          onPressed: editorHasFocus && canRedo && isEditMode ? redo : null,
                        ),
                      ),
                    ],
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
