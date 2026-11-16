import 'package:flutter/material.dart';

import '../../../models/note/note_format.dart';
import '../../constants/paddings.dart';

/// A format chosen in the [NoteFormatSheet], shared as text or as a file.
typedef NoteFormatChoice = ({NoteFormat format, bool asFile});

/// Sheet to choose a note format.
class NoteFormatSheet extends StatelessWidget {
  /// Bottom sheet with the [title] that lets the user choose a note format, as text and also as a file if [withFiles].
  const NoteFormatSheet({super.key, required this.title, this.withFiles = false});

  /// The title of the sheet.
  final String title;

  /// Whether the formats can also be chosen as files.
  final bool withFiles;

  @override
  Widget build(BuildContext context) {
    final choices = <NoteFormatChoice>[
      for (final format in NoteFormat.values) (format: format, asFile: false),
      if (withFiles)
        for (final format in NoteFormat.values) (format: format, asFile: true),
    ];

    return ListView(
      shrinkWrap: true,
      padding: Paddings.bottomSystemUi,
      children: [
        Padding(
          padding: Paddings.horizontal(24) + Paddings.bottom(8),
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        for (final choice in choices)
          ListTile(
            leading: Icon(choice.asFile ? Icons.description : choice.format.icon),
            title: Text(choice.asFile ? choice.format.fileTitle(context) : choice.format.title(context)),
            trailing: choice.asFile ? Text('.${choice.format.mimeType.extension}') : null,
            onTap: () => Navigator.pop(context, choice),
          ),
      ],
    );
  }
}

/// Asks the user to choose a note format in a sheet with the [title], as text and also as a file if [withFiles].
///
/// Returns `null` if the user closed the sheet without choosing.
Future<NoteFormatChoice?> selectNoteFormat(BuildContext context, {required String title, bool withFiles = false}) {
  return showModalBottomSheet<NoteFormatChoice>(
    context: context,
    clipBehavior: Clip.hardEdge,
    showDragHandle: true,
    useSafeArea: true,
    builder: (context) => NoteFormatSheet(title: title, withFiles: withFiles),
  );
}
