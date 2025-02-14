import 'package:flutter/material.dart';

import '../../models/note/note_status.dart';
import '../../providers/notifiers/notifiers.dart';
import 'app_bars/labels_selection_app_bar.dart';
import 'app_bars/notes_selection_app_bar.dart';

/// Top navigation with the app bar.
class TopNavigation extends StatelessWidget implements PreferredSizeWidget {
  /// Default constructor.
  const TopNavigation({
    super.key,
    required this.appbar,
    this.notesStatus,
  });

  /// App bar depending on the current route and whether the selection mode is enabled.
  final Widget appbar;

  /// Whether the current page is the notes list.
  final NoteStatus? notesStatus;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isNotesSelectionModeNotifier,
      builder: (context, isNotesSelectionMode, child) => ValueListenableBuilder(
        valueListenable: isLabelsSelectionModeNotifier,
        builder: (context, isLabelsSelectionMode, child) {
          if (isNotesSelectionMode && notesStatus != null) {
            return NotesSelectionAppBar(notesStatus: notesStatus!);
          } else if (isLabelsSelectionMode) {
            return const LabelsSelectionAppBar();
          }

          return appbar;
        },
      ),
    );
  }
}
