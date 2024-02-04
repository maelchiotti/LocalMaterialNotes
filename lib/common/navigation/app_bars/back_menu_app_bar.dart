import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/actions/back.dart';
import 'package:localmaterialnotes/common/actions/delete.dart';
import 'package:localmaterialnotes/common/actions/pin.dart';
import 'package:localmaterialnotes/common/actions/restore.dart';
import 'package:localmaterialnotes/common/navigation/app_bars/menu_options.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/editor/about_sheet.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/providers/editor_controller/editor_controller_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:share_plus/share_plus.dart';

class BackMenuAppBar extends ConsumerStatefulWidget {
  const BackMenuAppBar();

  @override
  ConsumerState<BackMenuAppBar> createState() => _BackAppBarState();
}

class _BackAppBarState extends ConsumerState<BackMenuAppBar> {
  Future<void> _onMenuOptionSelected(MenuOption menuOption) async {
    final note = ref.read(currentNoteProvider);

    if (note == null) return;

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

  void _toggleChecklist() {
    final editorController = ref.read(editorControllerProvider);

    if (editorController == null) return;

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
    final note = ref.read(currentNoteProvider);

    return AppBar(
      leading: BackButton(
        onPressed: () => backFromEditor(context, ref),
      ),
      actions: note == null
          ? null
          : [
              if (!note.deleted)
                IconButton(
                  icon: const Icon(Icons.checklist),
                  tooltip: localizations.tooltip_toggle_checkbox,
                  onPressed: _toggleChecklist,
                ),
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
  }
}
