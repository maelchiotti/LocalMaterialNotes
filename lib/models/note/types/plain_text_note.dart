part of '../note.dart';

/// Plain text note.
@JsonSerializable()
@Collection()
class PlainTextNote extends Note {
  /// The content of the note.
  @JsonKey(defaultValue: '')
  String content;

  /// A note with plain text content.
  PlainTextNote({
    required super.archived,
    required super.deleted,
    required super.pinned,
    required super.locked,
    required super.createdTime,
    required super.editedTime,
    required super.title,
    super.type = NoteType.plainText,
    required this.content,
  });

  /// Plain text note with empty title and content.
  factory PlainTextNote.empty() => PlainTextNote(
        archived: false,
        deleted: false,
        pinned: false,
        locked: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: '',
      );

  /// Plain text note with the provided [content].
  factory PlainTextNote.content(String content) => PlainTextNote(
        archived: false,
        deleted: false,
        pinned: false,
        locked: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: content,
      );

  /// Plain text note from [json] data.
  factory PlainTextNote.fromJson(Map<String, dynamic> json) => _$PlainTextNoteFromJson(json);

  /// Plain text note from [json] data, encrypted with [password].
  factory PlainTextNote.fromJsonEncrypted(Map<String, dynamic> json, String password) => _$PlainTextNoteFromJson(json)
    ..title = (json['title'] as String).isEmpty ? '' : EncryptionUtils().decrypt(password, json['title'] as String)
    ..content = EncryptionUtils().decrypt(password, json['content'] as String);

  /// Plain text note to JSON.
  Map<String, dynamic> toJson() => _$PlainTextNoteToJson(this);

  @override
  Note encrypted(String password) => this
    ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(password, title)
    ..content = EncryptionUtils().encrypt(password, content);

  @ignore
  @override
  String get plainText => content;

  @ignore
  @override
  String get markdown => content;

  @ignore
  @override
  String get contentPreview => plainText.trim();

  @ignore
  @override
  bool get isContentEmpty => content.isEmpty;
}
