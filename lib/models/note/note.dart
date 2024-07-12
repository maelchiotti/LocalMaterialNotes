import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fleather/fleather.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/encryption_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

part 'note.g.dart';

// ignore_for_file: must_be_immutable

/// Rich text note with title, content and metadata.
@JsonSerializable()
@Collection(inheritance: false)
class Note extends Equatable {
  /// Empty content in fleather data representation.
  static const String _emptyContent = '[{"insert":"\\n"}]';

  /// Id of the note.
  ///
  /// It's excluded from the JSON because it's fully managed by Isar.
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;

  /// Whether the note is selected.
  ///
  /// It's excluded from the JSON because it's only needed temporarily during multi-selection.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  bool selected = false;

  /// Whether the note is deleted.
  @Index()
  bool deleted;

  /// Whether the note is pinned.
  @Index()
  bool pinned;

  /// Date of creation.
  DateTime createdTime;

  /// Last date of edition.
  DateTime editedTime;

  /// Title (simple text).
  String title;

  /// Content (rich text in the fleather representation).
  String content;

  Note({
    required this.deleted,
    required this.pinned,
    required this.createdTime,
    required this.editedTime,
    required this.title,
    required this.content,
  });

  /// Note with empty title and content.
  factory Note.empty() => Note(
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: _emptyContent,
      );

  /// Note with the provided [content].
  factory Note.content(String content) => Note(
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: content,
      );

  /// Welcome note (localized).
  factory Note.welcome() => Note(
        deleted: false,
        pinned: true,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: hardcodedLocalizations.welcomeNoteTitle,
        content: '[{"insert":"${hardcodedLocalizations.welcomeNoteContent}\\n"}]',
      );

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  factory Note.fromJsonEncrypted(Map<String, dynamic> json, String password) {
    return _$NoteFromJson(json)
      ..id = uuid.v4() // Manually setting the ID for imports
      ..title = (json['title'] as String).isEmpty ? '' : EncryptionUtils().decrypt(password, json['title'] as String)
      ..content = EncryptionUtils().decrypt(password, json['content'] as String);
  }

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  Id get isarId {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < id!.length) {
      final codeUnit = id!.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }

  Note encrypted(String password) {
    return this
      ..title = isTitleEmpty ? '' : EncryptionUtils().encrypt(password, title)
      ..content = EncryptionUtils().encrypt(password, content);
  }

  /// Note content as plain text.
  @ignore
  String get plainText {
    return document.toPlainText();
  }

  /// Note content for the preview of the notes tiles.
  ///
  /// Formats the following rich text elements:
  ///   - Checkboxes TODO: only partially, see https://github.com/maelchiotti/LocalMaterialNotes/issues/121
  @ignore
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

  /// Note content as markdown.
  @ignore
  String get markdown {
    return parchmentMarkdownCodec.encode(document);
  }

  /// Note title and content to be shared as a single text.
  ///
  /// Uses the [contentPreview] for the content.
  @ignore
  String get shareText {
    return '$title\n\n$contentPreview';
  }

  /// Document containing the fleather content representation.
  @ignore
  ParchmentDocument get document {
    return ParchmentDocument.fromJson(jsonDecode(content) as List);
  }

  /// Whether the title is empty.
  @ignore
  bool get isTitleEmpty {
    return title.isEmpty;
  }

  /// Whether the content is empty.
  @ignore
  bool get isContentEmpty {
    return content == _emptyContent;
  }

  /// Whether the preview of the content is empty.
  @ignore
  bool get isContentPreviewEmpty {
    return contentPreview.isEmpty;
  }

  /// Whether the note is empty.
  ///
  /// Checks both the title and the content.
  @ignore
  bool get isEmpty {
    return isTitleEmpty && isContentEmpty;
  }

  /// Returns whether the [search] matches the note.
  ///
  /// Checks if the [search] is directly present in the title and the content,
  /// but also uses fuzzy search in the title. This cannot be done on the content for performance reasons.
  bool matchesSearch(String search) {
    final searchCleaned = search.toLowerCase().trim();

    final titleContains = title.toLowerCase().contains(searchCleaned);
    final contentContains = title.toLowerCase().contains(searchCleaned);

    final titleMatches = weightedRatio(plainText, searchCleaned) >= 50;

    return titleContains || contentContains || titleMatches;
  }

  /// Notes are sorted according to:
  ///   1. Their pin state.
  ///   2. The sort method chosen by the user.
  int compareTo(Note otherNote) {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

    if (pinned && !otherNote.pinned) {
      return -1;
    } else if (!pinned && otherNote.pinned) {
      return 1;
    } else {
      switch (sortMethod) {
        case SortMethod.date:
          return sortAscending
              ? createdTime.compareTo(otherNote.createdTime)
              : otherNote.createdTime.compareTo(createdTime);
        case SortMethod.title:
          return sortAscending ? title.compareTo(otherNote.title) : otherNote.title.compareTo(title);
        default:
          throw Exception('The sort method is not valid: $sortMethod');
      }
    }
  }

  @override
  @ignore
  List<Object?> get props => [id];
}
