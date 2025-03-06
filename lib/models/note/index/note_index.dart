import 'package:json_annotation/json_annotation.dart';

import '../note.dart';

part 'note_index.g.dart';

/// Notes search index.
@JsonSerializable()
class NoteIndex {
  /// The ID of the note.
  final int id;

  /// Whether the note is deleted.
  final bool deleted;

  /// The title of the note.
  final String title;

  /// The content of the note as plain text.
  final String content;

  /// The labels of the note.
  final List<String> labels;

  /// A search index for a note, allowing to search through its [title] and [content]
  /// and filter on whether it's [deleted] what [labels] it has.
  const NoteIndex({
    required this.id,
    required this.deleted,
    required this.title,
    required this.content,
    required this.labels,
  });

  /// Creates a [NoteIndex] from a [Note].
  factory NoteIndex.fromNote(Note note) => NoteIndex(
    id: note.isarId,
    deleted: note.deleted,
    title: note.title,
    content: note.plainText,
    labels: note.labelsNamesVisibleSorted,
  );

  /// Returns this [NoteIndex] as JSON.
  Map<String, dynamic> toJson() => _$NoteIndexToJson(this);
}
