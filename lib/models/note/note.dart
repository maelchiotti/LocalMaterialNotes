import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:fleather/fleather.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';

part 'note.g.dart';

// ignore_for_file: must_be_immutable

@JsonSerializable()
@Collection(inheritance: false)
class Note extends Equatable {
  static const String _emptyContent = '[{"insert":"\\n"}]';

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? id;
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
    this.id,
    required this.deleted,
    required this.pinned,
    required this.createdTime,
    required this.editedTime,
    required this.title,
    required this.content,
  });

  factory Note.empty() => Note(
        id: uuid.v4(),
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: _emptyContent,
      );

  factory Note.content(String content) => Note(
        id: uuid.v4(),
        deleted: false,
        pinned: false,
        createdTime: DateTime.now(),
        editedTime: DateTime.now(),
        title: '',
        content: content,
      );

  // Manually setting the ID for imports
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json)..id = uuid.v4();

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
        final nextOperation = i == operations.length - 1 ? null : operations[i + 1];

        print(nextOperation);

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

  @override
  @ignore
  List<Object?> get props => [id];
}
