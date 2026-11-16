import 'package:collection/collection.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar_community/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/environment.dart';
import '../../common/constants/labels.dart';
import '../../common/constants/notes.dart';
import '../../common/preferences/preference_key.dart';
import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../../models/note/note_status.dart';
import '../../models/note/types/note_type.dart';
import '../database_service.dart';
import 'notes_search.dart';

/// Service for the notes database.
///
/// This class is a singleton.
class NotesService {
  static final NotesService _singleton = NotesService._internal();

  /// Default constructor.
  factory NotesService() => _singleton;

  NotesService._internal();

  late final Isar _database;

  late final IsarCollection<PlainTextNote> _plainTextNotes;
  late final IsarCollection<MarkdownNote> _markdownNotes;
  late final IsarCollection<RichTextNote> _richTextNotes;
  late final IsarCollection<ChecklistNote> _checklistNotes;

  /// Ensures the notes service is initialized.
  Future<void> ensureInitialized() async {
    _database = DatabaseService().database;

    _plainTextNotes = DatabaseService().database.plainTextNotes;
    _markdownNotes = DatabaseService().database.markdownNotes;
    _richTextNotes = DatabaseService().database.richTextNotes;
    _checklistNotes = DatabaseService().database.checklistNotes;

    // If the app runs with the 'SCREENSHOTS' environment parameter,
    // clear all the notes and add the notes for the screenshots
    if (Environment.screenshots) {
      await clear();
      await putAll(screenshotNotes);
      await putLabels(screenshotNotes[4], screenshotLabels);
    }

    // If the app runs for the first time ever, add the welcome note
    if (await IsFirstRun.isFirstCall()) {
      await put(welcomeNote);
    }
  }

  /// Returns the total number of notes.
  Future<int> get count async {
    return await _plainTextNotes.count() +
        await _markdownNotes.count() +
        await _richTextNotes.count() +
        await _checklistNotes.count();
  }

  /// Returns all the notes.
  Future<List<Note>> getAll() async {
    return [
      ...await (_plainTextNotes.where().findAll()),
      ...await (_markdownNotes.where().findAll()),
      ...await (_richTextNotes.where().findAll()),
      ...await (_checklistNotes.where().findAll()),
    ];
  }

  /// Returns all the notes with the [ids].
  Future<List<Note>> getAllByIds(List<int> ids) async {
    return [
      ...(await (_plainTextNotes.getAll(ids))).nonNulls,
      ...(await (_markdownNotes.getAll(ids))).nonNulls,
      ...(await (_richTextNotes.getAll(ids))).nonNulls,
      ...(await (_checklistNotes.getAll(ids))).nonNulls,
    ];
  }

  /// Returns all the notes that are available.
  Future<List<Note>> getAllAvailable() async {
    return [
      ...await (_plainTextNotes.filter().archivedEqualTo(false).deletedEqualTo(false).findAll()),
      ...await (_markdownNotes.filter().archivedEqualTo(false).deletedEqualTo(false).findAll()),
      ...await (_richTextNotes.filter().archivedEqualTo(false).deletedEqualTo(false).findAll()),
      ...await (_checklistNotes.filter().archivedEqualTo(false).deletedEqualTo(false).findAll()),
    ];
  }

  /// Returns all the notes that are available filtered by the [label].
  Future<List<Note>> getAllAvailableFilteredByLabel({required Label label}) async {
    return [
      ...await (_plainTextNotes
          .filter()
          .archivedEqualTo(false)
          .deletedEqualTo(false)
          .labels((q) => q.nameEqualTo(label.name))
          .findAll()),
      ...await (_markdownNotes
          .filter()
          .archivedEqualTo(false)
          .deletedEqualTo(false)
          .labels((q) => q.nameEqualTo(label.name))
          .findAll()),
      ...await (_richTextNotes
          .filter()
          .archivedEqualTo(false)
          .deletedEqualTo(false)
          .labels((q) => q.nameEqualTo(label.name))
          .findAll()),
      ...await (_checklistNotes
          .filter()
          .archivedEqualTo(false)
          .deletedEqualTo(false)
          .labels((q) => q.nameEqualTo(label.name))
          .findAll()),
    ];
  }

  /// Returns all the notes that are archived.
  Future<List<Note>> getAllArchived() async {
    return [
      ...await (_plainTextNotes.where().archivedEqualTo(true).findAll()),
      ...await (_markdownNotes.where().archivedEqualTo(true).findAll()),
      ...await (_richTextNotes.where().archivedEqualTo(true).findAll()),
      ...await (_checklistNotes.where().archivedEqualTo(true).findAll()),
    ];
  }

  /// Returns all the notes that are deleted.
  Future<List<Note>> getAllDeleted() async {
    return [
      ...await (_plainTextNotes.where().deletedEqualTo(true).findAll()),
      ...await (_markdownNotes.where().deletedEqualTo(true).findAll()),
      ...await (_richTextNotes.where().deletedEqualTo(true).findAll()),
      ...await (_checklistNotes.where().deletedEqualTo(true).findAll()),
    ];
  }

  /// The maximum number of notes returned by a search.
  static const searchLimit = 50;

  /// Returns the notes with the [notesStatus] that match the [search], at most [searchLimit].
  ///
  /// A note matches when each word of the [search] starts a word of its title, or is contained in its content (except
  /// for the notes that require an authentication). The notes whose title matches come first.
  ///
  /// If [label] is set, the search should be performed on the notes that have that label.
  ///
  /// The search runs in an isolate, so that it doesn't freeze the interface. The notes are loaded here by their IDs.
  Future<List<Note>> search(String search, NoteStatus notesStatus, String? label) async {
    final words = Isar.splitWords(search.toLowerCase());

    if (words.isEmpty) {
      return [];
    }

    final SearchParameters parameters = (
      databaseName: DatabaseService.databaseName,
      databaseDirectory: DatabaseService().databaseDirectory,
      words: words,
      archived: notesStatus == NoteStatus.archived,
      deleted: notesStatus == NoteStatus.deleted,
      label: label,
      lockNote: PreferenceKey.lockNote.preferenceOrDefault,
      lockLabel: PreferenceKey.lockLabel.preferenceOrDefault,
      limit: searchLimit,
    );

    final results = await searchNotesInIsolate(parameters);

    return [
      ...(await _getAllByResults(results.titleMatches)).sorted(),
      ...(await _getAllByResults(results.contentMatches)).sorted(),
    ];
  }

  /// Returns the notes of the search [results], from their collection.
  Future<List<Note>> _getAllByResults(List<SearchResult> results) async {
    List<int> ids(NoteType type) => results.where((result) => result.type == type).map((r) => r.isarId).toList();

    final notes = <Note?>[
      ...await _plainTextNotes.getAll(ids(NoteType.plainText)),
      ...await _markdownNotes.getAll(ids(NoteType.markdown)),
      ...await _richTextNotes.getAll(ids(NoteType.richText)),
      ...await _checklistNotes.getAll(ids(NoteType.checklist)),
    ];

    return notes.nonNulls.toList();
  }

  /// Puts the [note] in the database.
  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      switch (note) {
        case final PlainTextNote _:
          await _plainTextNotes.put(note);
        case final MarkdownNote _:
          await _markdownNotes.put(note);
        case final RichTextNote _:
          await _richTextNotes.put(note);
        case final ChecklistNote _:
          await _checklistNotes.put(note);
      }
    });
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    await _database.writeTxn(() => _putAllInTransaction(notes));
  }

  /// Puts the [notes] in their collections. Must be called inside a write transaction, since Isar cannot nest them.
  Future<void> _putAllInTransaction(List<Note> notes) async {
    await _plainTextNotes.putAll(notes.whereType<PlainTextNote>().toList());
    await _markdownNotes.putAll(notes.whereType<MarkdownNote>().toList());
    await _richTextNotes.putAll(notes.whereType<RichTextNote>().toList());
    await _checklistNotes.putAll(notes.whereType<ChecklistNote>().toList());
  }

  /// Updates the [note] with the [labels] in the database.
  Future<void> putLabels(Note note, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      await note.labels.reset();
      note.labels.addAll(labels);
      await note.labels.save();
    });
  }

  /// Updates the [note] with the added [labels] in the database.
  Future<void> addLabels(List<Note> notes, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      for (final note in notes) {
        note.labels.addAll(labels);
        await note.labels.save();
      }
    });
  }

  /// Imports the [labels] and the [notes] in a single transaction, so that a failure leaves the database untouched.
  ///
  /// Only the labels whose name is not in the database yet are added. Each note is linked to the labels
  /// whose names are in its [notesLabelsNames] entry.
  Future<void> import(List<Label> labels, List<Note> notes, List<List<String>> notesLabelsNames) async {
    assert(
      notes.length == notesLabelsNames.length,
      'The list of labels names (${notesLabelsNames.length} items) should be the same length as the list of notes (${notes.length} notes)',
    );

    await _database.writeTxn(() async {
      final databaseLabels = await _database.labels.where().findAll();
      final newLabels = labels.where((label) => !databaseLabels.contains(label)).toSet().toList();
      await _database.labels.putAll(newLabels);
      final allLabels = [...databaseLabels, ...newLabels];

      await _putAllInTransaction(notes);

      for (var i = 0; i < notes.length; i++) {
        final note = notes[i];
        final labelsNames = notesLabelsNames[i];

        note.labels.addAll(allLabels.where((label) => labelsNames.contains(label.name)));
        await note.labels.save();
      }
    });
  }

  /// Deletes the [note] from the database.
  Future<void> delete(Note note) async {
    await _database.writeTxn(() async {
      switch (note) {
        case final PlainTextNote _:
          await _plainTextNotes.delete(note.isarId);
        case final MarkdownNote _:
          await _markdownNotes.delete(note.isarId);
        case final RichTextNote _:
          await _richTextNotes.delete(note.isarId);
        case final ChecklistNote _:
          await _checklistNotes.delete(note.isarId);
      }
    });
  }

  /// Deletes the [notes] from the database.
  Future<void> deleteAll(List<Note> notes) async {
    final plainTextNotesIds = notes.whereType<PlainTextNote>().map((note) => note.isarId).toList();
    final markdownNotesIds = notes.whereType<MarkdownNote>().map((note) => note.isarId).toList();
    final richTextNotesIds = notes.whereType<RichTextNote>().map((note) => note.isarId).toList();
    final checklistNotesIds = notes.whereType<ChecklistNote>().map((note) => note.isarId).toList();

    await _database.writeTxn(() async {
      await _plainTextNotes.deleteAll(plainTextNotesIds);
      await _markdownNotes.deleteAll(markdownNotesIds);
      await _richTextNotes.deleteAll(richTextNotesIds);
      await _checklistNotes.deleteAll(checklistNotesIds);
    });
  }

  /// Deletes all the deleted notes from the database.
  Future<void> emptyBin() async {
    await _database.writeTxn(() async {
      await _plainTextNotes.where().deletedEqualTo(true).deleteAll();
      await _markdownNotes.where().deletedEqualTo(true).deleteAll();
      await _richTextNotes.where().deletedEqualTo(true).deleteAll();
      await _checklistNotes.where().deletedEqualTo(true).deleteAll();
    });
  }

  /// Deletes all the notes from the database.
  Future<void> clear() async {
    await _database.writeTxn(() async {
      await _plainTextNotes.clear();
      await _markdownNotes.clear();
      await _richTextNotes.clear();
      await _checklistNotes.clear();
    });
  }

  /// Deletes all the notes from the bin that have been deleted for longer than [delay].
  Future<void> removeFromBin(Duration delay) async {
    final deletedNotes = await getAllDeleted();

    final notesToRemove = deletedNotes.where((note) {
      if (note.deletedTime == null) {
        return false;
      }

      final now = DateTime.timestamp();
      final durationSinceDeleted = now.difference(note.deletedTime!);

      return durationSinceDeleted > delay;
    }).toList();

    if (notesToRemove.isEmpty) {
      return;
    }

    logger.i('Automatically removing ${notesToRemove.length} notes from the bin');

    await deleteAll(notesToRemove);
  }
}
