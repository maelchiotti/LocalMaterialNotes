import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_bars/editor_app_bar.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/preferences/preference_key.dart';
import '../../common/widgets/keys.dart';
import '../../common/widgets/placeholders/loading_placeholder.dart';
import '../../models/note/note.dart';
import '../../models/note/note_status.dart';
import '../../providers/notifiers/notifiers.dart';
import 'widgets/checklist/checklist_editor.dart';
import 'widgets/editor_labels_list.dart';
import 'widgets/markdown/markdown_editor.dart';
import 'widgets/plain_text/plain_text_editor.dart';
import 'widgets/rich_text/rich_text_editor.dart';
import 'widgets/rich_text/rich_text_editor_toolbar.dart';
import 'widgets/title_editor.dart';

/// Editor page.
class NotesEditorPage extends ConsumerStatefulWidget {
  /// Page allowing to edit a note.
  const NotesEditorPage({
    super.key,
    required this.readOnly,
    required this.isNewNote,
  });

  /// Whether the page is read only.
  final bool readOnly;

  /// Whether the note was just created.
  final bool isNewNote;

  @override
  ConsumerState<NotesEditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<NotesEditorPage> {
  void requestEditorFocus() {
    editorFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault();
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault();
    final enableLabels = PreferenceKey.enableLabels.getPreferenceOrDefault();
    final showLabelsListInEditorPage = PreferenceKey.showLabelsListInEditorPage.getPreferenceOrDefault();

    return ValueListenableBuilder(
      valueListenable: currentNoteNotifier,
      builder: (context, currentNote, child) {
        return ValueListenableBuilder(
          valueListenable: isEditorInEditModeNotifier,
          builder: (context, isEditorInEditMode, child) {
            if (currentNote == null) {
              return const LoadingPlaceholder();
            }

            final readOnly = widget.readOnly || (showEditorModeButton && !isEditorInEditMode);
            final autofocus = widget.isNewNote && !focusTitleOnNewNote;
            final showLabelsList =
                enableLabels && showLabelsListInEditorPage && currentNote.labelsVisibleSorted.isNotEmpty;

            Widget contentEditor;
            Widget? toolbar;
            switch (currentNote) {
              case PlainTextNote note:
                contentEditor = PlainTextEditor(
                  note: note,
                  isNewNote: widget.isNewNote,
                  readOnly: readOnly,
                  autofocus: autofocus,
                );
              case RichTextNote note:
                final fleatherController = FleatherController(document: note.document);
                fleatherControllerNotifier.value = fleatherController;
                contentEditor = RichTextEditor(
                  note: note,
                  fleatherController: fleatherController,
                  isNewNote: widget.isNewNote,
                  readOnly: readOnly,
                  autofocus: autofocus,
                );
                toolbar = RichTextEditorToolbar(
                  fleatherController: fleatherController,
                );
              case MarkdownNote note:
                contentEditor = MarkdownEditor(
                  note: note,
                  isNewNote: widget.isNewNote,
                  readOnly: readOnly,
                  autofocus: autofocus,
                );
              case ChecklistNote note:
                contentEditor = ChecklistEditor(
                  note: note,
                  isNewNote: widget.isNewNote,
                  readOnly: readOnly,
                );
            }

            return Scaffold(
              appBar: const TopNavigation(
                appbar: EditorAppBar(
                  key: Keys.appBarEditor,
                ),
                notesStatus: NoteStatus.available,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        TitleEditor(
                          readOnly: widget.readOnly,
                          isNewNote: widget.isNewNote,
                          onSubmitted: requestEditorFocus,
                        ),
                        Gap(8.0),
                        Expanded(
                          child: contentEditor,
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        if (showLabelsList) EditorLabelsList(readOnly: widget.readOnly),
                        if (toolbar != null && isEditorInEditMode && !currentNote.deleted) toolbar,
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
