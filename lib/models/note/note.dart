import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fleather/fleather.dart';
import 'package:flutter_checklist/checklist.dart';
import 'package:isar_community/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:remove_markdown/remove_markdown.dart';

import '../../../common/constants/constants.dart';
import '../../common/files/encryption_utils.dart';
import '../../common/preferences/enums/sort_method.dart';
import '../../common/preferences/preference_key.dart';
import '../label/label.dart';
import 'note_status.dart';
import 'types/note_type.dart';

part 'note.g.dart';
part 'types/checklist_note.dart';
part 'types/markdown_note.dart';
part 'types/plain_text_note.dart';
part 'types/rich_text_note.dart';

/// Converts the [labels] to a JSON-compatible list of strings.
List<String> labelToJson(IsarLinks<Label> labels) => labels.map((label) => label.name).toList();

/// Base class of the notes.
sealed class Note implements Comparable<Note> {
  /// The regex expression used to count the number of words in the content of the note.
  final RegExp _wordsCountRegex = RegExp(r'[\w-]+');

  /// The ID of the note as an [int] used by isar.
  Id get isarId => _idHash;

  /// The ID of the note as a [String] used by the application.
  @JsonKey(includeFromJson: false, includeToJson: false)
  String id = uuid.v4();

  /// The type of the note.
  @ignore
  @JsonKey(includeToJson: true, includeFromJson: false)
  NoteType type;

  /// Whether the note is archived.
  @Index()
  @JsonKey(defaultValue: false)
  bool archived;

  /// Whether the note is deleted.
  @Index()
  @JsonKey(defaultValue: false)
  bool deleted;

  /// Whether the note is pinned.
  @Index()
  @JsonKey(defaultValue: false)
  bool pinned;

  /// Whether the note is locked.
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool locked;

  /// The time when the note was created.
  DateTime createdTime;

  /// The last time when the note was edited (title or content).
  DateTime editedTime;

  /// The time when the note was deleted (if applicable).
  DateTime? deletedTime;

  /// The title of the note.
  @JsonKey(defaultValue: '')
  String title;

  /// The labels used to categorize the note.
  @JsonKey(includeFromJson: false, includeToJson: true, toJson: labelToJson)
  IsarLinks<Label> labels = IsarLinks<Label>();

  /// Whether the note is selected.
  ///
  /// Excluded from JSON and the database because it's only needed temporarily during multi-selection.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  bool selected = false;

  /// Default constructor of a note.
  Note({
    required this.archived,
    required this.deleted,
    required this.pinned,
    this.locked = false,
    required this.createdTime,
    required this.editedTime,
    this.deletedTime,
    required this.title,
    required this.type,
  }) : assert(!(archived && deleted), 'A note cannot be archived and deleted at the same time');

  /// Returns this note with the [title] and the content encrypted using the [password].
  Note encrypted(String password);

  /// The status of the note.
  @ignore
  NoteStatus get status {
    if (archived) {
      return NoteStatus.archived;
    } else if (deleted) {
      return NoteStatus.deleted;
    }

    return NoteStatus.available;
  }

  /// The content as plain text.
  @ignore
  String get plainText;

  /// The content as markdown.
  @ignore
  String get contentAsMarkdown;

  /// The content for the preview of the notes tiles.
  @ignore
  String get contentPreview;

  /// The title and the content joined together to be shared as a single text.
  @ignore
  String get shareText => '$title\n\n$contentPreview';

  /// The number of words in the content.
  @ignore
  int get wordsCount => _wordsCountRegex.allMatches(plainText).length;

  /// The number of characters in the content.
  @ignore
  int get charactersCount => plainText.length;

  /// Whether the title is empty.
  @ignore
  bool get isTitleEmpty => title.isEmpty;

  /// Whether the content is empty.
  @ignore
  bool get isContentEmpty;

  /// Whether the preview of the content is empty.
  @ignore
  bool get isContentPreviewEmpty => contentPreview.isEmpty;

  /// Whether the note is empty (title and content).
  @ignore
  bool get isEmpty => isTitleEmpty && isContentEmpty;

  /// Returns the visible [labels] of the note as a sorted list.
  @ignore
  List<Label> get labelsVisibleSorted => labels.toList().where((label) => label.visible).sorted();

  /// The names of the visible [labels] of the note as a sorted list.
  @ignore
  List<String> get labelsNamesVisibleSorted => labelsVisibleSorted.map((label) => label.name).toList();

  /// The number of labels of the note.
  @ignore
  int get labelsCount => labels.toList().length;

  /// Whether at least one label is locked.
  @ignore
  bool get hasLockedLabel => labels.any((label) => label.locked);

  /// The [labels] as markdown.
  @ignore
  String get labelsAsMarkdown => '> ${labelsNamesVisibleSorted.join(', ')}';

  /// Notes are sorted according to:
  ///   1. Their pin state.
  ///   2. The sort method chosen by the user.
  @override
  int compareTo(Note other) {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.preferenceOrDefault;

    if (pinned && !other.pinned) {
      return -1;
    } else if (!pinned && other.pinned) {
      return 1;
    } else {
      switch (sortMethod) {
        case SortMethod.createdDate:
          return sortAscending ? createdTime.compareTo(other.createdTime) : other.createdTime.compareTo(createdTime);
        case SortMethod.editedDate:
          return sortAscending ? editedTime.compareTo(other.editedTime) : other.editedTime.compareTo(editedTime);
        case SortMethod.title:
          return sortAscending ? title.compareTo(other.title) : other.title.compareTo(title);
        default:
          throw Exception('The sort method is not valid: $sortMethod');
      }
    }
  }

  @override
  bool operator ==(Object other) => other is Note && other.runtimeType == runtimeType && other.id == id;

  @ignore
  @override
  int get hashCode => id.hashCode;

  @ignore
  int get _idHash {
    var hash = 0xcbf29ce484222325;

    var i = 0;
    while (i < id.length) {
      final codeUnit = id.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }

    return hash;
  }
}
