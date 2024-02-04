import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/empty_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/common/placeholders/loading_placeholder.dart';
import 'package:localmaterialnotes/common/widgets/note_tile.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/platform_manager.dart';
import 'package:localmaterialnotes/utils/quick_actions_manager.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage();

  @override
  ConsumerState<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends ConsumerState<NotesPage> {
  Future<void> _refresh() async {
    await ref.read(notesProvider.notifier).get();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsAndroidApp) {
      QuickActionsManager().init(context, ref);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ScrollConfiguration(
        behavior: scrollBehavior,
        child: ref.watch(notesProvider).when(
          data: (notes) {
            if (notes.isEmpty) {
              return EmptyPlaceholder.notes();
            }

            return ListView.builder(
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
        ),
      ),
    );
  }
}
