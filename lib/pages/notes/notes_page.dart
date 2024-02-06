import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/constants/paddings.dart';
import 'package:localmaterialnotes/utils/quick_actions_manager.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage();

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  @override
  Widget build(BuildContext context) {
    QuickActionsManager().init(context, ref);

    return ref.watch(notesProvider).when(
      data: (notes) {
        if (notes.isEmpty) return EmptyPlaceholder.notes();

        return ListView.builder(
          padding: Paddings.custom.fab,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return NoteTile(notes[index]);
          },
        );
      },
      error: (error, stackTrace) {
        return const ErrorPlaceholder();
      },
      loading: () {
        return const LoadingPlaceholder();
      },
    );
  }
}
