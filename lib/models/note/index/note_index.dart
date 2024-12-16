import 'package:json_annotation/json_annotation.dart';
import 'package:localmaterialnotes/models/note/note.dart';

part 'note_index.g.dart';

@JsonSerializable()
class NoteIndex {
  final int id;
  final bool deleted;
  final String title;
  final String content;
  final List<String> labels;

  const NoteIndex({
    required this.id,
    required this.deleted,
    required this.title,
    required this.content,
    required this.labels,
  });

  factory NoteIndex.fromNote(Note note) {
    return NoteIndex(
      id: note.id,
      deleted: note.deleted,
      title: note.title,
      content: note.plainText,
      labels: note.labelsNamesVisibleSorted,
    );
  }

  Map<String, dynamic> toJson() => _$NoteIndexToJson(this);
}
