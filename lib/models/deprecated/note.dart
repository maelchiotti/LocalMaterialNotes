import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../label/label.dart';

part 'note.g.dart';

// ignore_for_file: must_be_immutable, public_member_api_docs

List<String> _labelToJson(IsarLinks<Label> labels) => labels.map((label) => label.name).toList();

/// Legacy model of the rich text note.
@JsonSerializable()
@Collection()
@Deprecated('Legacy model of the rich text note')
class Note {
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  bool selected = false;

  bool deleted;

  bool pinned;

  DateTime createdTime;

  DateTime editedTime;

  String title;

  String content;

  @JsonKey(includeFromJson: false, includeToJson: true, toJson: _labelToJson)
  IsarLinks<Label> labels = IsarLinks<Label>();

  Note({
    required this.deleted,
    required this.pinned,
    required this.createdTime,
    required this.editedTime,
    required this.title,
    required this.content,
  });
}
