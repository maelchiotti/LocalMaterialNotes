import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/paddings.dart';
import '../../common/navigation/app_bars/editor_app_bar.dart';
import '../../common/navigation/top_navigation.dart';
import '../../common/preferences/preference_key.dart';
import '../../common/widgets/keys.dart';
import '../../common/widgets/placeholders/loading_placeholder.dart';
import '../../models/note/note.dart';
import '../../providers/notifiers/notifiers.dart';
import 'widgets/editor_field.dart';
import '../../utils/keys.dart';
import 'widgets/editor_labels_list.dart';
import 'widgets/plain_text/plain_text_editor.dart';
import 'widgets/rich_text/rich_text_editor.dart';
import 'widgets/rich_text/rich_text_editor_toolbar.dart';
import 'widgets/title_editor.dart';

/// Page displaying the note editor.
class NotesEditorPage extends ConsumerStatefulWidget {
  /// Default constructor.
  const NotesEditorPage({
    super.key,
    required this.readOnly,
    required this.isNewNote,
  });

  /// Whether the page is read only.
  final bool readOnly;

  /// Whether this is a new note, so the title or content field should be auto focused
  /// and the editor mode should be forced to editing.
  final bool isNewNote;

  @override
  ConsumerState<NotesEditorPage> createState() => _EditorState();
}

class _EditorState extends ConsumerState<NotesEditorPage> {
  /// Request focus on the content editor.
  void requestEditorFocus() {
    editorFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final showEditorModeButton = PreferenceKey.editorModeButton.getPreferenceOrDefault();
    final focusTitleOnNewNote = PreferenceKey.focusTitleOnNewNote.getPreferenceOrDefault();
    final showToolbar = PreferenceKey.showToolbar.getPreferenceOrDefault();
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
            }

            return Scaffold(
              appBar: const TopNavigation(
                appbar: EditorAppBar(
                  key: Keys.appBarEditor,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: Paddings.pageButBottom,
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
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        if (showLabelsList) EditorLabelsList(readOnly: widget.readOnly),
                        if (toolbar != null && showToolbar && isEditorInEditMode && !currentNote.deleted) toolbar,
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
