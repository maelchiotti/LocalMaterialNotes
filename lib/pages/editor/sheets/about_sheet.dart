import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
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

    final labelsCount = note.labels.toList().length;

    final wordCount = RegExp(r'[\w-]+').allMatches(note.contentPreview).length;
    final charactersCount = note.contentPreview.length;

    final isLabelsEnabled = PreferenceKey.enableLabels.getPreferenceOrDefault();

    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(
          title: Text(l.about_created),
          trailing: Text(note.createdTime.yMMMMd_at_Hm),
        ),
        ListTile(
          title: Text(l.about_last_edited),
          trailing: Text(note.editedTime.yMMMMd_at_Hm),
        ),
        if (isLabelsEnabled)
          ListTile(
            title: Text(l.about_labels),
            trailing: Text('$labelsCount'),
          ),
        ListTile(
          title: Text(l.about_words),
          trailing: Text('$wordCount'),
        ),
        ListTile(
          title: Text(l.about_characters),
          trailing: Text('$charactersCount'),
        ),
      ],
    );
  }
}
