import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:fleather/fleather.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/constants/constants.dart';
import '../../common/files/encryption_utils.dart';
import '../../common/preferences/enums/sort_method.dart';
import '../../common/preferences/preference_key.dart';
import '../label/label.dart';

part 'note.g.dart';

part 'plain_text/plain_text_note.dart';

part 'rich_text/rich_text_note.dart';

/// Converts the [labels] to a JSON-compatible list of strings.
List<String> labelToJson(IsarLinks<Label> labels) => labels.map((label) => label.name).toList();

/// Base class of the notes.
sealed class Note implements Comparable<Note> {
  /// The ID of the note.
  ///
  /// Excluded from JSON because it's fully managed by Isar.
  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;

  /// Whether the note is selected.
  ///
  /// Excluded from JSON because it's only needed temporarily during multi-selection.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  bool selected = false;

  /// Whether the note is deleted.
  @Index()
  bool deleted;

  /// Whether the note is pinned.
  @Index()
  bool pinned;

  /// The date of creation of the note.
  DateTime createdTime;

  /// The last date of edition of the note, including events such as toggling the pinned state.
  DateTime editedTime;

  /// The title of the note.
  String title;

  /// The labels used to categorize the note.
  @JsonKey(includeFromJson: false, includeToJson: true, toJson: labelToJson)
  IsarLinks<Label> labels = IsarLinks<Label>();

  /// Default constructor of a note.
  Note({
    required this.deleted,
    required this.pinned,
    required this.createdTime,
    required this.editedTime,
    required this.title,
  });

  /// Returns this note with the [title] and the content encrypted using the [password].
  Note encrypted(String password);

  /// Note content as plain text.
  @ignore
  String get plainText;

  /// Note content as markdown.
  @ignore
  String get markdown;

  /// Note content for the preview of the notes tiles.
  @ignore
  String get contentPreview;

  /// Note title and content to be shared as a single text.
  @ignore
  String get shareText => '$title\n\n$contentPreview';

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

  /// Returns the names of the visible [labels] of the note as a sorted list.
  @ignore
  List<String> get labelsNamesVisibleSorted => labelsVisibleSorted.map((label) => label.name).toList();

  /// Notes are sorted according to:
  ///   1. Their pin state.
  ///   2. The sort method chosen by the user.
  @override
  int compareTo(Note other) {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault();

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
}
