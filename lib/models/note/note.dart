import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fleather/fleather.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';

part 'note.g.dart';

// ignore_for_file: must_be_immutable

@JsonSerializable()
@Collection(inheritance: false)
class Note extends Equatable {
  static const String _emptyContent = '[{"insert":"\\n"}]';

  @JsonKey(includeFromJson: false, includeToJson: false)
  Id id = Isar.autoIncrement;
  @Index()
  late bool deleted;
  @Index()
  late bool pinned;
  late DateTime createdTime;
  late DateTime editedTime;
  late String title;
  late String content;
  @JsonKey(includeFromJson: false, includeToJson: false)
  @ignore
  late bool selected = false;

  Note({
    required this.deleted,
    required this.pinned,
    required this.createdTime,
    required this.editedTime,
    required this.title,
    required this.content,
  });

  factory Note.empty() => Note(
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: _emptyContent,
      );

  factory Note.content(String content) => Note(
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: content,
      );

  factory Note.welcome() => Note(
        deleted: false,
        pinned: true,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: hardcodedLocalizations.welcomeNoteTitle,
        content: '[{"insert":"${hardcodedLocalizations.welcomeNoteContent}\\n"}]',
      );

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  Map<String, dynamic> toJson() => _$NoteToJson(this);

  @ignore
  String get plainText {
    return document.toPlainText();
  }

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

  @ignore
  String get markdown {
    return parchmentMarkdownCodec.encode(document);
  }

  @ignore
  String get shareText {
    return '$title\n\n$contentPreview';
  }

  @ignore
  ParchmentDocument get document {
    return ParchmentDocument.fromJson(jsonDecode(content) as List);
  }

  @ignore
  bool get isTitleEmpty {
    return title.isEmpty;
  }

  @ignore
  bool get isContentEmpty {
    return content == _emptyContent;
  }

  @ignore
  bool get isContentPreviewEmpty {
    return contentPreview.isEmpty;
  }

  @ignore
  bool get isEmpty {
    return isTitleEmpty && isContentEmpty;
  }

  bool matchesSearch(String search) {
    final searchCleaned = search.toLowerCase().trim();

    final titleContains = title.toLowerCase().contains(searchCleaned);
    final contentContains = title.toLowerCase().contains(searchCleaned);

    final titleMatches = weightedRatio(plainText, searchCleaned) >= 50;

    return titleContains || contentContains || titleMatches;
  }

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
          throw Exception();
      }
    }
  }

  @override
  @ignore
  List<Object?> get props => [id];
}
