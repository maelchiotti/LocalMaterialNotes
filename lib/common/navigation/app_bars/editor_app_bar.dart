import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/back.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/actions/pin.dart';
import 'package:localmaterialnotes/common/actions/restore.dart';
import 'package:localmaterialnotes/common/navigation/menu_options.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/editor/sheets/about_sheet.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:share_plus/share_plus.dart';

class EditorAppBar extends ConsumerStatefulWidget {
  const EditorAppBar();

  @override
  ConsumerState<EditorAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends ConsumerState<EditorAppBar> {
  Future<void> _onMenuOptionSelected(MenuOption menuOption) async {
    // Manually close the keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    final note = currentNoteNotifier.value;

    if (note == null) {
      return;
    }

    switch (menuOption) {
      case MenuOption.togglePin:
        await togglePinNote(context, ref, note);
      case MenuOption.share:
        await _shareNote(note);
      case MenuOption.delete:
        await deleteNote(context, ref, note);
      case MenuOption.restore:
        await restoreNote(context, ref, note);
      case MenuOption.deletePermanently:
        await permanentlyDeleteNote(context, ref, note);
      case MenuOption.about:
        showModalBottomSheet(
          context: context,
          clipBehavior: Clip.hardEdge,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => const AboutSheet(),
        );
    }
  }

  void _undo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canUndo) {
      return;
    }

    editorController.undo();
  }

  void _redo() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null || !editorController.canRedo) {
      return;
    }

    editorController.redo();
  }

  void _toggleChecklist() {
    final editorController = fleatherControllerNotifier.value;

    if (editorController == null) {
      return;
    }

    final isToggled = editorController.getSelectionStyle().containsSame(ParchmentAttribute.block.checkList);
    editorController.formatSelection(
      isToggled ? ParchmentAttribute.block.checkList.unset : ParchmentAttribute.block.checkList,
    );
  }

  Future<void> _shareNote(Note note) async {
    await Share.share(note.shareText, subject: note.title);
  }

  @override
  Widget build(BuildContext context) {
    final note = currentNoteNotifier.value;
    final editorController = fleatherControllerNotifier.value;

    final showUndoRedoButtons = PreferenceKey.showUndoRedoButtons.getPreferenceOrDefault<bool>();
    final showChecklistButton = PreferenceKey.showChecklistButton.getPreferenceOrDefault<bool>();

    return ValueListenableBuilder(
      valueListenable: fleatherFieldHasFocusNotifier,
      builder: (context, hasFocus, child) {
        return AppBar(
          leading: BackButton(
            onPressed: () => backFromEditor(context, ref),
          ),
          actions: note == null
              ? null
              : [
                  if (!note.deleted) ...[
                    if (showUndoRedoButtons)
                      ValueListenableBuilder(
                        valueListenable: fleatherControllerCanUndoNotifier,
                        builder: (context, canUndo, child) {
                          return IconButton(
                            icon: const Icon(Icons.undo),
                            tooltip: localizations.tooltip_toggle_checkbox,
                            onPressed: hasFocus && canUndo && editorController != null && editorController.canUndo
                                ? _undo
                                : null,
                          );
                        },
                      ),
                    if (showUndoRedoButtons)
                      ValueListenableBuilder(
                        valueListenable: fleatherControllerCanRedoNotifier,
                        builder: (context, canRedo, child) {
                          return IconButton(
                            icon: const Icon(Icons.redo),
                            tooltip: localizations.tooltip_toggle_checkbox,
                            onPressed: hasFocus && canRedo ? _redo : null,
                          );
                        },
                      ),
                    if (showChecklistButton)
                      IconButton(
                        icon: const Icon(Icons.checklist),
                        tooltip: localizations.tooltip_toggle_checkbox,
                        onPressed: hasFocus ? _toggleChecklist : null,
                      ),
                  ],
                  PopupMenuButton<MenuOption>(
                    itemBuilder: (context) {
                      return (note.deleted
                          ? [
                              MenuOption.restore.popupMenuItem(),
                              MenuOption.deletePermanently.popupMenuItem(),
                            ]
                          : [
                              MenuOption.togglePin.popupMenuItem(note.pinned),
                              MenuOption.share.popupMenuItem(),
                              MenuOption.delete.popupMenuItem(),
                            ])
                        ..addAll(
                          [
                            MenuOption.about.popupMenuItem(),
                          ],
                        );
                    },
                    onSelected: _onMenuOptionSelected,
                  ),
                  Padding(padding: Paddings.custom.appBarActionsEnd),
                ],
        );
      },
    );
  }
}
