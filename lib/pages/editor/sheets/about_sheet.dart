import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';

/// Sheets that displays information about the note.
///
/// Contains:
///   - Creation time.
///   - Last edit time.
///   - Number of words.
///   - Number of characters.
class AboutSheet extends StatelessWidget {
  const AboutSheet();

  @override
  Widget build(BuildContext context) {
    final note = currentNoteNotifier.value;

    if (note == null) {
      return const ErrorPlaceholder();
    }

    final wordCount = RegExp(r'[\w-]+').allMatches(note.contentPreview).length;
    final charactersCount = note.contentPreview.length;

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
          trailing: Text('$wordCount'),
        ),
        ListTile(
          title: Text(localizations.about_characters),
          trailing: Text('$charactersCount'),
        ),
      ],
    );
  }
}
