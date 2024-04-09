import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/providers/current_note/current_note_provider.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';

class AboutSheet extends ConsumerWidget {
  const AboutSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(currentNoteProvider);

    if (note == null) {
      return const ErrorPlaceholder();
    }

    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(localizations.about_created),
          trailing: Text(note.createdTime.yMMMMd_at_Hm),
        ),
        ListTile(
          title: Text(localizations.about_last_edited),
          trailing: Text(note.editedTime.yMMMMd_at_Hm),
        ),
        ListTile(
          title: Text(localizations.about_words),
          trailing: Text(RegExp(r'[\w-]+').allMatches(note.contentDisplay).length.toString()),
        ),
        ListTile(
          title: Text(localizations.about_characters),
          trailing: Text(note.contentDisplay.length.toString()),
        ),
      ],
    );
  }
}
