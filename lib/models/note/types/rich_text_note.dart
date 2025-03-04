part of '../note.dart';

/// Rich text note.
@JsonSerializable()
@Collection()
class RichTextNote extends Note {
  /// Empty content in fleather data representation.
  static const _emptyContent = '[{"insert":"\\n"}]';

  /// The content of the note, as rich text in the fleather representation.
  @JsonKey(defaultValue: _emptyContent)
  String content;

  /// A note with rich text content.
  RichTextNote({
    required super.archived,
    required super.deleted,
    required super.pinned,
    required super.locked,
    required super.createdTime,
    required super.editedTime,
    required super.title,
    super.type = NoteType.richText,
    required this.content,
  });

  /// Rich text note with empty title and content.
  factory RichTextNote.empty() => RichTextNote(
        archived: false,
        deleted: false,
        pinned: false,
        locked: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: _emptyContent,
      );

  /// Rich text note with the provided [content].
  factory RichTextNote.content(String content) => RichTextNote(
        archived: false,
        deleted: false,
        pinned: false,
        locked: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: content,
      );

  /// Rich text note from [json] data.
  factory RichTextNote.fromJson(Map<String, dynamic> json) => _$RichTextNoteFromJson(json);

  /// Rich text note from [json] data, encrypted with [password].
  factory RichTextNote.fromJsonEncrypted(Map<String, dynamic> json, String password) => _$RichTextNoteFromJson(json)
    ..title = (json['title'] as String).isEmpty ? '' : EncryptionUtils().decrypt(password, json['title'] as String)
    ..content = EncryptionUtils().decrypt(password, json['content'] as String);

  /// Rich text note to JSON.
  Map<String, dynamic> toJson() => _$RichTextNoteToJson(this);

  @override
  Note encrypted(String password) => this
    ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(password, title)
    ..content = EncryptionUtils().encrypt(password, content);

  /// Document containing the fleather content representation.
  @ignore
  ParchmentDocument get document => ParchmentDocument.fromJson(jsonDecode(content) as List);

  @ignore
  @override
  String get plainText => document.toPlainText();

  @ignore
  @override
  String get markdown => parchmentMarkdownCodec.encode(document);

  @ignore
  @override
  String get contentPreview {
    var content = '';

    for (final child in document.root.children) {
      final operations = child.toDelta().toList();

      for (var i = 0; i < operations.length; i++) {
        final operation = operations[i];

        // Skip horizontal rules
        if (operation.data is Map &&
            (operation.data as Map).containsKey('_type') &&
            (operation.data as Map)['_type'] == 'hr') {
          continue;
        }

        final nextOperation = i == operations.length - 1 ? null : operations[i + 1];

        final checklist = nextOperation != null &&
            nextOperation.attributes != null &&
            nextOperation.attributes!.containsKey('block') &&
            nextOperation.attributes!['block'] == 'cl';

        if (checklist) {
          final checked = nextOperation.attributes!.containsKey('checked');
          content += '${checked ? '✅' : '⬜'} ${operation.value}';
        } else {
          content += operation.value.toString();
        }
      }
    }

    return content.trim();
  }

  @ignore
  @override
  bool get isContentEmpty => content == _emptyContent;
}
