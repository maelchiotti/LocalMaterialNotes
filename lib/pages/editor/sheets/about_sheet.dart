import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../common/constants/sizes.dart';
import '../../../common/extensions/build_context_extension.dart';
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

        final areLabelsEnabled = PreferenceKey.enableLabels.preferenceOrDefault;

        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: Text(context.l.about_type),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(currentNote.type.icon, size: Sizes.iconSmall.size),
                  Gap(8.0),
                  Text(currentNote.type.title(context)),
                ],
              ),
            ),
            ListTile(
              title: Text(context.l.about_created),
              trailing: Text(currentNote.createdTime.yMMMMd_at_Hm(context)),
            ),
            ListTile(
              title: Text(context.l.about_last_edited),
              trailing: Text(currentNote.editedTime.yMMMMd_at_Hm(context)),
            ),
            if (areLabelsEnabled)
              ListTile(title: Text(context.l.about_labels), trailing: Text('${currentNote.labelsCount}')),
            ListTile(title: Text(context.l.about_words), trailing: Text('${currentNote.wordsCount}')),
            ListTile(title: Text(context.l.about_characters), trailing: Text('${currentNote.charactersCount}')),
          ],
        );
      },
    );
  }
}
