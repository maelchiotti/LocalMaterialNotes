part of '../note.dart';

/// Checklist note.
@JsonSerializable()
@Collection()
class ChecklistNote extends Note {
  /// The list of checkboxes of this checklist.
  List<bool> checkboxes;

  /// The list of texts of this checklist.
  List<String> texts;

  /// A note with checklist content.
  ChecklistNote({
    required super.archived,
    required super.deleted,
    required super.pinned,
    required super.createdTime,
    required super.editedTime,
    required super.title,
    super.type = NoteType.checklist,
    required this.checkboxes,
    required this.texts,
  }) : assert(
          checkboxes.length == texts.length,
          'The lists of checkboxes and texts of a checklist note are different: ${checkboxes.length} and ${texts.length}',
        );

  /// Checklist note with empty title and 1 empty checklist item.
  factory ChecklistNote.empty() => ChecklistNote(
        archived: false,
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        checkboxes: [false],
        texts: [''],
      );

  /// Checklist note with the provided [content].
  factory ChecklistNote.content(List<ChecklistLine> content) => ChecklistNote(
        archived: false,
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        checkboxes: content.map((checklistLine) => checklistLine.toggled).toList(),
        texts: content.map((checklistLine) => checklistLine.text).toList(),
      );

  /// Checklist note from [json] data.
  factory ChecklistNote.fromJson(Map<String, dynamic> json) => _$ChecklistNoteFromJson(json);

  /// Checklist note from [json] data, encrypted with [password].
  factory ChecklistNote.fromJsonEncrypted(Map<String, dynamic> json, String password) {
    String title = json['title'];
    List texts = json['texts'];

    return _$ChecklistNoteFromJson(json)
      ..title = title.isEmpty ? '' : EncryptionUtils().decrypt(password, title)
      ..texts = texts.isEmpty ? [] : texts.map((text) => EncryptionUtils().decrypt(password, text)).toList();
  }

  /// Checklist note to JSON.
  Map<String, dynamic> toJson() => _$ChecklistNoteToJson(this);

  @override
  Note encrypted(String password) {
    return this
      ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(password, title)
      ..texts = texts.map((text) => EncryptionUtils().encrypt(password, text)).toList();
  }

  @ignore
  @override
  String get plainText {
    StringBuffer plainText = StringBuffer();

    for (int index = 0; index < checkboxes.length; index++) {
      final checked = checkboxes[index];
      final text = texts[index];

      plainText.writeln('${checked ? '✅' : '⬜'} $text');
    }

    return plainText.toString();
  }

  @ignore
  @override
  String get markdown {
    StringBuffer plainText = StringBuffer();

    for (int index = 0; index < checkboxes.length; index++) {
      final checked = checkboxes[index];
      final text = texts[index];

      plainText.writeln('${checked ? '[x]' : '[ ]'} $text');
    }

    return plainText.toString();
  }

  @ignore
  @override
  String get contentPreview => plainText.trim();

  @ignore
  @override
  bool get isContentEmpty => checkboxes.isEmpty;

  /// The list of [ChecklistLine] of this checklist.
  @ignore
  List<ChecklistLine> get checklistLines {
    final checklistLines = <ChecklistLine>[];

    for (int index = 0; index < checkboxes.length; index++) {
      final checked = checkboxes[index];
      final text = texts[index];

      checklistLines.add((toggled: checked, text: text));
    }

    return checklistLines;
  }
}
