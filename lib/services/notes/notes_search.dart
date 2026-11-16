import 'dart:convert';
import 'dart:isolate';

import 'package:fleather/fleather.dart';
import 'package:isar_community/isar.dart';

import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../../models/note/types/note_type.dart';
import '../database_service.dart';

/// A note found by a search, identified by its [type] (its collection) and its [isarId].
typedef SearchResult = ({NoteType type, int isarId});

/// The parameters of a search, sent to the isolate that performs it.
typedef SearchParameters = ({
  String databaseName,
  String databaseDirectory,
  List<String> words,
  bool archived,
  bool deleted,
  String? label,
  bool lockNote,
  bool lockLabel,
  int limit,
});

/// The notes found by a search: first the ones whose title matches every word, then the ones whose content does.
typedef SearchResults = ({List<SearchResult> titleMatches, List<SearchResult> contentMatches});

/// Searches the notes matching the [parameters] in a new isolate, so that the search doesn't freeze the interface.
///
/// Top-level function, so that the closure sent to the isolate only captures the [parameters].
Future<SearchResults> searchNotesInIsolate(SearchParameters parameters) {
  return Isolate.run(() => searchNotesInDatabase(parameters));
}

/// Searches the notes matching the [parameters], in an isolate that opens its own instance of the database.
///
/// A note matches when each word starts a word of its title, or is contained in its content. The content of the notes
/// that require an authentication is never searched, so that the results never reveal what they contain.
///
/// Only returns the identifiers of the notes, so that the notes are loaded by the main isolate.
Future<SearchResults> searchNotesInDatabase(SearchParameters parameters) async {
  final openedInstance = Isar.getInstance(parameters.databaseName);
  final database =
      openedInstance ??
      await Isar.open(
        DatabaseService.schemas,
        name: parameters.databaseName,
        directory: parameters.databaseDirectory,
        inspector: false,
      );

  try {
    final words = parameters.words;
    final archived = parameters.archived;
    final deleted = parameters.deleted;
    final label = parameters.label;

    // One query per collection, on the titles only or on the titles and the contents
    final fetchers = <_Fetch>[
      ({required bool titleOnly, required int offset, required int limit}) => database.plainTextNotes
          .filter()
          .archivedEqualTo(archived)
          .deletedEqualTo(deleted)
          .optional(label != null, (q) => q.labels((q2) => q2.nameEqualTo(label!)))
          .allOf<String, PlainTextNote>(
            words,
            (q, word) => q.group(
              (q2) => titleOnly
                  ? q2.titleIndexedElementStartsWith(word)
                  : q2.titleIndexedElementStartsWith(word).or().contentContains(word, caseSensitive: false),
            ),
          )
          .offset(offset)
          .limit(limit)
          .findAll(),
      ({required bool titleOnly, required int offset, required int limit}) => database.markdownNotes
          .filter()
          .archivedEqualTo(archived)
          .deletedEqualTo(deleted)
          .optional(label != null, (q) => q.labels((q2) => q2.nameEqualTo(label!)))
          .allOf<String, MarkdownNote>(
            words,
            (q, word) => q.group(
              (q2) => titleOnly
                  ? q2.titleIndexedElementStartsWith(word)
                  : q2.titleIndexedElementStartsWith(word).or().contentContains(word, caseSensitive: false),
            ),
          )
          .offset(offset)
          .limit(limit)
          .findAll(),
      ({required bool titleOnly, required int offset, required int limit}) => database.richTextNotes
          .filter()
          .archivedEqualTo(archived)
          .deletedEqualTo(deleted)
          .optional(label != null, (q) => q.labels((q2) => q2.nameEqualTo(label!)))
          .allOf<String, RichTextNote>(
            words,
            (q, word) => q.group(
              (q2) => titleOnly
                  ? q2.titleIndexedElementStartsWith(word)
                  : q2.titleIndexedElementStartsWith(word).or().contentContains(word, caseSensitive: false),
            ),
          )
          .offset(offset)
          .limit(limit)
          .findAll(),
      ({required bool titleOnly, required int offset, required int limit}) => database.checklistNotes
          .filter()
          .archivedEqualTo(archived)
          .deletedEqualTo(deleted)
          .optional(label != null, (q) => q.labels((q2) => q2.nameEqualTo(label!)))
          .allOf<String, ChecklistNote>(
            words,
            (q, word) => q.group(
              (q2) => titleOnly
                  ? q2.titleIndexedElementStartsWith(word)
                  : q2.titleIndexedElementStartsWith(word).or().textsElementContains(word, caseSensitive: false),
            ),
          )
          .offset(offset)
          .limit(limit)
          .findAll(),
    ];

    final titleMatches = <SearchResult>[];
    final contentMatches = <SearchResult>[];
    final limit = parameters.limit;
    int count() => titleMatches.length + contentMatches.length;

    // First the notes whose title matches, with the index of the titles
    for (final fetch in fetchers) {
      if (count() >= limit) {
        break;
      }

      final notes = await fetch(titleOnly: true, offset: 0, limit: limit - count());
      titleMatches.addAll(notes.map((note) => (type: note.type, isarId: note.isarId)));
    }

    // Then the notes whose content matches, by batches so that only the needed notes are read. The candidates are
    // checked in Dart, to skip the content of the locked notes and the JSON syntax of the rich text notes
    final titleMatchesIds = titleMatches.toSet();
    for (final fetch in fetchers) {
      for (var offset = 0; count() < limit; offset += _batchSize) {
        final candidates = await fetch(titleOnly: false, offset: offset, limit: _batchSize);

        for (final note in candidates) {
          final result = (type: note.type, isarId: note.isarId);

          if (count() >= limit) {
            break;
          }

          if (titleMatchesIds.contains(result) || !_contentMatches(note, words, parameters)) {
            continue;
          }

          contentMatches.add(result);
        }

        if (candidates.length < _batchSize) {
          break;
        }
      }
    }

    return (titleMatches: titleMatches, contentMatches: contentMatches);
  } finally {
    // Close the instance opened by this isolate
    if (openedInstance == null) {
      await database.close();
    }
  }
}

/// Returns the content of the [note] in which to search.
///
/// For a rich text note, it's the text of the document rather than its JSON, or the raw content if it can't be decoded
/// (the logger of the main isolate isn't available here).
String _searchableContent(Note note) {
  switch (note) {
    case final RichTextNote note:
      try {
        return ParchmentDocument.fromJson(jsonDecode(note.content) as List).toPlainText();
      } catch (_) {
        return note.content;
      }
    case final ChecklistNote note:
      return note.texts.join('\n');
    case final PlainTextNote note:
      return note.content;
    case final MarkdownNote note:
      return note.content;
  }
}

/// The number of candidates read at once when searching the contents.
const _batchSize = 50;

/// Fetches the notes of one collection matching the words of a search, on the titles only if [titleOnly].
typedef _Fetch = Future<List<Note>> Function({required bool titleOnly, required int offset, required int limit});

/// Returns whether the [note] matches each of the [words] in its title or its content.
///
/// The content of a note that requires an authentication is never searched.
bool _contentMatches(Note note, List<String> words, SearchParameters parameters) {
  final requiresAuthentication =
      (parameters.lockNote && note.locked) || (parameters.lockLabel && note.labels.any((label) => label.locked));
  if (requiresAuthentication) {
    return false;
  }

  final titleWords = note.titleIndexed;
  final content = _searchableContent(note).toLowerCase();

  return words.every((word) => titleWords.any((titleWord) => titleWord.startsWith(word)) || content.contains(word));
}
