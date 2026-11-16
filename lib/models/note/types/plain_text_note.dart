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
    super.locked,
    required super.createdTime,
    required super.editedTime,
    super.deletedTime,
    required super.title,
    super.type = NoteType.plainText,
    required this.content,
  });

  /// Plain text note with empty title and content.
  factory PlainTextNote.empty() => PlainTextNote(
    archived: false,
    deleted: false,
    pinned: false,
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
    createdTime: DateTime.now(),
    editedTime: DateTime.now(),
    title: '',
    content: content,
  );

  /// Plain text note from [json] data.
  factory PlainTextNote.fromJson(Map<String, dynamic> json) => _$PlainTextNoteFromJson(json);

  /// Plain text note from [json] data, decrypted with the [encrypter].
  factory PlainTextNote.fromJsonEncrypted(Map<String, dynamic> json, Encrypter encrypter) =>
      _$PlainTextNoteFromJson(json)
        ..title = (json['title'] as String).isEmpty ? '' : EncryptionUtils().decrypt(encrypter, json['title'] as String)
        ..content = EncryptionUtils().decrypt(encrypter, json['content'] as String);

  /// Plain text note to JSON.
  @override
  Map<String, dynamic> toJson() => _$PlainTextNoteToJson(this);

  @override
  Note encrypted(Encrypter encrypter) => this
    ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(encrypter, title)
    ..content = EncryptionUtils().encrypt(encrypter, content);

  @ignore
  @override
  String get contentAsText => content;

  @ignore
  @override
  String get contentAsMarkdown => content;

  @ignore
  @override
  String get contentPreview => contentAsText.trim();

  @ignore
  @override
  bool get isContentEmpty => content.isEmpty;
}
