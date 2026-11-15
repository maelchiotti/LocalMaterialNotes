import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../common/enums/mime_type.dart';
import '../../common/extensions/build_context_extension.dart';
import 'note.dart';

/// The formats in which a note can be copied, shared or exported.
enum NoteFormat {
  /// Plain text: the title and the content without formatting.
  text(MimeType.text, Icons.notes),

  /// Markdown: the title as a heading and the content with its formatting.
  markdown(MimeType.markdown, SimpleIcons.markdown);

  /// The mime type of the files in this format.
  final MimeType mimeType;

  /// The icon of this format.
  final IconData icon;

  /// A format with the [mimeType] of its files and an [icon].
  const NoteFormat(this.mimeType, this.icon);

  /// Returns the title of this format.
  String title(BuildContext context) {
    return switch (this) {
      text => context.l.note_format_text,
      markdown => context.l.note_format_markdown,
    };
  }

  /// Returns the title of the files in this format.
  String fileTitle(BuildContext context) {
    return switch (this) {
      text => context.l.note_format_text_file,
      markdown => context.l.note_format_markdown_file,
    };
  }

  /// Returns the [note] (title and content) in this format.
  String format(Note note) {
    return switch (this) {
      text => note.asText,
      markdown => note.asMarkdown,
    };
  }

  /// Returns the [notes] in this format, separated so that each note can be told apart.
  String formatAll(List<Note> notes) {
    final separator = switch (this) {
      text => '\n\n----------\n\n',
      markdown => '\n\n---\n\n',
    };

    return notes.map(format).join(separator).trim();
  }

  /// Returns a file name in this format for each of the [notes], made unique by adding a number when needed.
  List<String> fileNames(List<Note> notes) {
    final extension = mimeType.extension;
    final names = <String>[];

    for (final note in notes) {
      final baseName = note.fileNameWithoutExtension;
      var name = '$baseName.$extension';

      for (var index = 2; names.contains(name); index++) {
        name = '$baseName ($index).$extension';
      }

      names.add(name);
    }

    return names;
  }
}
