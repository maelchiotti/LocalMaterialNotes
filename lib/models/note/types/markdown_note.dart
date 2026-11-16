part of '../note.dart';

/// Plain text note.
@JsonSerializable()
@Collection()
class MarkdownNote extends Note {
  /// The content of the note.
  @JsonKey(defaultValue: '')
  String content;

  /// A note with plain text content.
  MarkdownNote({
    required super.archived,
    required super.deleted,
    required super.pinned,
    super.locked,
    required super.createdTime,
    required super.editedTime,
    super.deletedTime,
    required super.title,
    super.type = NoteType.markdown,
    required this.content,
  });

  /// Plain text note with empty title and content.
  factory MarkdownNote.empty() => MarkdownNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime.now(),
    editedTime: DateTime.now(),
    title: '',
    content: '',
  );

  /// Plain text note with the provided [content].
  factory MarkdownNote.content(String content) => MarkdownNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime.now(),
    editedTime: DateTime.now(),
    title: '',
    content: content,
  );

  /// Plain text note from [json] data.
  factory MarkdownNote.fromJson(Map<String, dynamic> json) => _$MarkdownNoteFromJson(json);

  /// Markdown note from [json] data, decrypted with the [encrypter].
  factory MarkdownNote.fromJsonEncrypted(Map<String, dynamic> json, Encrypter encrypter) => _$MarkdownNoteFromJson(json)
    ..title = (json['title'] as String).isEmpty ? '' : EncryptionUtils().decrypt(encrypter, json['title'] as String)
    ..content = EncryptionUtils().decrypt(encrypter, json['content'] as String);

  /// Plain text note to JSON.
  @override
  Map<String, dynamic> toJson() => _$MarkdownNoteToJson(this);

  @override
  Note encrypted(Encrypter encrypter) => this
    ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(encrypter, title)
    ..content = EncryptionUtils().encrypt(encrypter, content);

  @ignore
  @override
  String get contentAsText => content.removeMarkdown();

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
