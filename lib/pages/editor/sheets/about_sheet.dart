import 'package:flutter/material.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extensions/date_time_extensions.dart';
import '../../../common/preferences/preference_key.dart';
import '../../../common/widgets/placeholders/loading_placeholder.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Note about sheet.
class AboutSheet extends StatelessWidget {
  /// Bottom sheet that displays information about a note.
  const AboutSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentNoteNotifier,
      builder: (context, currentNote, child) {
        if (currentNote == null) {
          return const LoadingPlaceholder();
        }

        final areLabelsEnabled = PreferenceKey.enableLabels.getPreferenceOrDefault();

        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(l.about_type),
              trailing: Text(currentNote.type),
            ),
            ListTile(
              title: Text(l.about_created),
              trailing: Text(currentNote.createdTime.yMMMMd_at_Hm),
            ),
            ListTile(
              title: Text(l.about_last_edited),
              trailing: Text(currentNote.editedTime.yMMMMd_at_Hm),
            ),
            if (areLabelsEnabled)
              ListTile(
                title: Text(l.about_labels),
                trailing: Text('${currentNote.labelsCount}'),
              ),
            ListTile(
              title: Text(l.about_words),
              trailing: Text('${currentNote.wordsCount}'),
            ),
            ListTile(
              title: Text(l.about_characters),
              trailing: Text('${currentNote.charactersCount}'),
            ),
          ],
        );
      },
    );
  }
}
