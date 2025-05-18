import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../common/constants/constants.dart';
import '../../common/extensions/build_context_extension.dart';
import '../../common/navigation/app_bars/notes/editor_app_bar.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/preferences/preference_key.dart';
import '../../common/widgets/placeholders/loading_placeholder.dart';
import '../../models/note/note.dart';
import '../../models/note/note_status.dart';
import '../../providers/notes/notes_provider.dart';
import '../../providers/notifiers/notifiers.dart';
import '../lock/lock_page.dart';
import 'widgets/editor_labels_list.dart';
import 'widgets/editors/checklist_editor.dart';
import 'widgets/editors/markdown_editor.dart';
import 'widgets/editors/plain_text_editor.dart';
import 'widgets/editors/rich_text_editor.dart';
import 'widgets/editors/title_editor.dart';
import 'widgets/toolbar/toolbar.dart';

/// Editor page.
class EditorPage extends ConsumerStatefulWidget {
  /// Page allowing to edit a note.
  const EditorPage({super.key, required this.readOnly, required this.isNewNote});

  /// Whether the page is read only.
  final bool readOnly;

  /// Whether the note was just created.
  final bool isNewNote;

  @override
  ConsumerState<EditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<EditorPage> {
  @override
  void dispose() {
    // ignore: avoid_ref_inside_state_dispose
    globalRef.read(notesProvider(status: NoteStatus.available).notifier).removeEmpty();
    // ignore: avoid_ref_inside_state_dispose
    globalRef.read(notesProvider(status: NoteStatus.archived).notifier).removeEmpty();

    super.dispose();
  }

  void requestEditorFocus() {
    editorFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentNoteNotifier,
      builder: (context, currentNote, child) {
        return ValueListenableBuilder(
          valueListenable: isEditModeNotifier,
          builder: (context, isEditorInEditMode, child) {
            if (currentNote == null) {
              return const LoadingPlaceholder();
            }

            final lockNote = PreferenceKey.lockNote.preferenceOrDefault;
            final lockLabel = PreferenceKey.lockLabel.preferenceOrDefault;

            final showEditorModeButton = PreferenceKey.editorModeButton.preferenceOrDefault;
            final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.preferenceOrDefault;
            final enableLabels = PreferenceKey.enableLabels.preferenceOrDefault;
            final showLabelsListInEditorPage = PreferenceKey.showLabelsListInEditorPage.preferenceOrDefault;

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
                toolbar = Toolbar(fleatherController: fleatherController);
              case MarkdownNote note:
                contentEditor = MarkdownEditor(
                  note: note,
                  isNewNote: widget.isNewNote,
                  readOnly: readOnly,
                  autofocus: autofocus,
                );
              case ChecklistNote note:
                contentEditor = ChecklistEditor(note: note, isNewNote: widget.isNewNote, readOnly: readOnly);
            }

            final editor = Scaffold(
              appBar: const TopNavigation(appbar: EditorAppBar(), notesStatus: NoteStatus.available),
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
                        Expanded(child: contentEditor),
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

            // If the note should not be locked, directly return the editor
            final shouldLockNote = lockNote && currentNote.locked;
            final shouldLockLabel = lockLabel && currentNote.hasLockedLabel;
            final shouldLock = shouldLockNote || shouldLockLabel;
            if (!shouldLock) {
              return editor;
            }

            return ValueListenableBuilder(
              valueListenable: lockNoteNotifier,
              builder: (context, locked, child) {
                return locked
                    ? LockPage(
                      back: false,
                      lockNotifier: lockNoteNotifier,
                      description: context.l.lock_page_description_note,
                      reason: context.l.lock_page_reason_note,
                    )
                    : editor;
              },
            );
          },
        );
      },
    );
  }
}
