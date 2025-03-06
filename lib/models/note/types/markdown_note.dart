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

  /// Plain text note from [json] data, encrypted with [password].
  factory MarkdownNote.fromJsonEncrypted(Map<String, dynamic> json, String password) =>
      _$MarkdownNoteFromJson(json)
        ..title = (json['title'] as String).isEmpty ? '' : EncryptionUtils().decrypt(password, json['title'] as String)
        ..content = EncryptionUtils().decrypt(password, json['content'] as String);

  /// Plain text note to JSON.
  Map<String, dynamic> toJson() => _$MarkdownNoteToJson(this);

  @override
  Note encrypted(String password) =>
      this
        ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(password, title)
        ..content = EncryptionUtils().encrypt(password, content);

  @ignore
  @override
  String get plainText => content.removeMarkdown();

  @ignore
  @override
  String get contentAsMarkdown => content;

  @ignore
  @override
  String get contentPreview => plainText.trim();

  @ignore
  @override
  bool get isContentEmpty => content.isEmpty;
}
