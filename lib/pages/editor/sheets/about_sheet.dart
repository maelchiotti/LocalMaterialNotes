import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/common/widgets/placeholders/error_placeholder.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Sheets that displays information about the note.
///
/// Contains:
///   - Creation time.
///   - Last edit time.
///   - Number of words.
///   - Number of characters.
class AboutSheet extends StatelessWidget {
  /// Default constructor.
  const AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final note = currentNoteNotifier.value;

    if (note == null) {
      return const ErrorPlaceholder(exception: 'The note is null in the about sheet');
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
