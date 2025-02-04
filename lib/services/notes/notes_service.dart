import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/environment.dart';
import '../../common/constants/labels.dart';
import '../../common/constants/notes.dart';
import '../../models/label/label.dart';
import '../../models/note/index/note_index.dart';
import '../../models/note/note.dart';
import '../database_service.dart';

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
  late final IsarCollection<RichTextNote> _richTextNotes;
  late final IsarCollection<ChecklistNote> _checklistNotes;

  late final MimirIndex _index;

  /// Ensures the notes service is initialized.
  Future<void> ensureInitialized() async {
    _database = DatabaseService().database;

    _plainTextNotes = DatabaseService().database.plainTextNotes;
    _richTextNotes = DatabaseService().database.richTextNotes;
    _checklistNotes = DatabaseService().database.checklistNotes;

    _index = await DatabaseService().mimir.openIndex(
      'notes',
      primaryKey: 'id',
      searchableFields: ['title', 'content'],
    );

    // If the number of indexed notes is different from the total number of notes, re-index them all
    // (this should only be needed on the first launch after updating from a version that didn't have the index feature)
    final indexNotesCount = (await _index.numberOfDocuments).toInt();
    final notesCount = await count;
    if (indexNotesCount != notesCount) {
      logger.i('Re-indexing all notes ($indexNotesCount notes were indexed out of $notesCount)');

      await _updateAllIndexes(await getAll());
    }

    // If the app runs with the 'INTEGRATION_TEST' environment parameter,
    // clear all the notes and add the notes for the integration tests
    if (Environment.integrationTest) {
      await clear();
      await putAll(integrationTestNotes);
    }

    // If the app runs with the 'SCREENSHOTS' environment parameter,
    // clear all the notes and add the notes for the screenshots
    else if (Environment.screenshots) {
      await clear();
      await putAll(screenshotNotes);
      await putLabels(screenshotNotes[4], screenshotLabels);
    }

    // If the app runs for the first time ever, add the welcome note
    else if (await IsFirstRun.isFirstCall()) {
      await put(welcomeNote);
    }
  }

  Future<void> _updateIndex(Note note) async {
    final document = NoteIndex.fromNote(note).toJson();
    await _index.addDocument(document);
  }

  Future<void> _updateAllIndexes(List<Note> notes) async {
    final documents = notes.map((note) => NoteIndex.fromNote(note).toJson()).toList();
    await _index.addDocuments(documents);
  }

  Future<void> _deleteIndex(Note note) async {
    await _index.deleteDocument(note.id.toString());
  }

  Future<void> _deleteAllIndexes(List<Note> notes) async {
    final notesIds = notes.map((note) => note.id.toString()).toList();
    await _index.deleteDocuments(notesIds);
  }

  /// Returns the total number of notes.
  Future<int> get count async {
    return await _plainTextNotes.count() + await _richTextNotes.count() + await _checklistNotes.count();
  }

  /// Returns all the notes.
  Future<List<Note>> getAll() async => [
        ...await (_plainTextNotes.where().findAll()),
        ...await (_richTextNotes.where().findAll()),
        ...await (_checklistNotes.where().findAll()),
      ];

  /// Returns all the notes with the [ids].
  Future<List<Note>> getAllByIds(List<int> ids) async => [
        ...(await (_plainTextNotes.getAll(ids))).nonNulls,
        ...(await (_richTextNotes.getAll(ids))).nonNulls,
        ...(await (_checklistNotes.getAll(ids))).nonNulls,
      ];

  /// Returns all the notes that are not deleted.
  Future<List<Note>> getAllNotDeleted() async => [
        ...await (_plainTextNotes.where().deletedEqualTo(false).findAll()),
        ...await (_richTextNotes.where().deletedEqualTo(false).findAll()),
        ...await (_checklistNotes.where().deletedEqualTo(false).findAll()),
      ];

  /// Returns all the notes that are not deleted filtered by the [label].
  Future<List<Note>> getAllNotDeletedFilteredByLabel({required Label label}) async => [
        ...await (_plainTextNotes
            .where()
            .deletedEqualTo(false)
            .filter()
            .labels((q) => q.nameEqualTo(label.name))
            .findAll()),
        ...await (_richTextNotes
            .where()
            .deletedEqualTo(false)
            .filter()
            .labels((q) => q.nameEqualTo(label.name))
            .findAll()),
        ...await (_checklistNotes
            .where()
            .deletedEqualTo(false)
            .filter()
            .labels((q) => q.nameEqualTo(label.name))
            .findAll()),
      ];

  /// Returns all the notes that are deleted.
  Future<List<Note>> getAllDeleted() async => [
        ...await (_plainTextNotes.where().deletedEqualTo(true).findAll()),
        ...await (_richTextNotes.where().deletedEqualTo(true).findAll()),
        ...await (_checklistNotes.where().deletedEqualTo(true).findAll()),
      ];

  /// Returns all the notes that match the [search].
  ///
  /// If [notesPage] is set to `true`, the search should be performed on the deleted notes.
  ///
  /// If [label] is set, the search should be performed on the notes that have that label.
  Future<List<Note>> search(String search, bool notesPage, String? label) async {
    final searchFilter = Mimir.and(
      [
        Mimir.where('deleted', isEqualTo: (!notesPage).toString()),
        if (label != null) Mimir.where('labels', containsAtLeastOneOf: [label]),
      ],
    );
    final searchResults = await _index.search(
      query: search,
      filter: searchFilter,
    );
    final notesIds = searchResults.map((Map<String, dynamic> noteIndex) => noteIndex['id'] as int).toList();

    final notes = (await getAllByIds(notesIds));

    // Check that all search results correspond to an existing note
    if (notesIds.length != notes.length) {
      final cases = notesIds.length - notes.length;
      logger.w('Some notes search results have an ID that does not correspond to an existing note ($cases cases)');
    }

    return notes;
  }

  /// Puts the [note] in the database.
  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      switch (note) {
        case final PlainTextNote _:
          await _plainTextNotes.put(note);
        case final RichTextNote _:
          await _richTextNotes.put(note);
        case final ChecklistNote _:
          await _checklistNotes.put(note);
      }
    });

    await _updateIndex(note);
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    final plainTextNotes = notes.whereType<PlainTextNote>().toList();
    final richTextNotes = notes.whereType<RichTextNote>().toList();
    final checklistNotes = notes.whereType<ChecklistNote>().toList();

    await _database.writeTxn(() async {
      await _plainTextNotes.putAll(plainTextNotes);
      await _richTextNotes.putAll(richTextNotes);
      await _checklistNotes.putAll(checklistNotes);
    });

    await _updateAllIndexes(notes);
  }

  /// Updates the [note] with the [labels] in the database.
  Future<void> putLabels(Note note, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      await note.labels.reset();
      note.labels.addAll(labels);
      await note.labels.save();
    });

    await _updateIndex(note);
  }

  /// Updates the [note] with the added [labels] in the database.
  Future<void> addLabels(List<Note> notes, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      for (final note in notes) {
        note.labels.addAll(labels);
        await note.labels.save();
      }
    });

    await _updateAllIndexes(notes);
  }

  /// Updates the [notes] with their corresponding [notesLabels] in the database.
  Future<void> putAllLabels(List<Note> notes, List<List<Label>> notesLabels) async {
    assert(
      notes.length == notesLabels.length,
      'The list of labels (${notesLabels.length} items) should be the same length as the list of notes (${notes.length} notes)',
    );

    await _database.writeTxn(() async {
      for (var i = 0; i < notes.length; i++) {
        final note = notes[i];
        final labels = notesLabels[i];

        await note.labels.reset();
        note.labels.addAll(labels);
        await note.labels.save();
      }
    });

    await _updateAllIndexes(notes);
  }

  /// Deletes the [note] from the database.
  Future<void> delete(Note note) async {
    await _database.writeTxn(() async {
      switch (note) {
        case final PlainTextNote _:
          await _plainTextNotes.delete(note.isarId);
        case final RichTextNote _:
          await _richTextNotes.delete(note.isarId);
        case final ChecklistNote _:
          await _checklistNotes.delete(note.isarId);
      }
    });

    await _deleteIndex(note);
  }

  /// Deletes the [notes] from the database.
  Future<void> deleteAll(List<Note> notes) async {
    final plainTextNotesIds = notes.whereType<PlainTextNote>().map((note) => note.isarId).toList();
    final richTextNotesIds = notes.whereType<RichTextNote>().map((note) => note.isarId).toList();
    final checklistNotesIds = notes.whereType<ChecklistNote>().map((note) => note.isarId).toList();

    await _database.writeTxn(() async {
      await _plainTextNotes.deleteAll(plainTextNotesIds);
      await _richTextNotes.deleteAll(richTextNotesIds);
      await _checklistNotes.deleteAll(checklistNotesIds);
    });

    await _deleteAllIndexes(notes);
  }

  /// Deletes all the deleted notes from the database.
  Future<void> emptyBin() async {
    final notes = await getAllDeleted();

    await _database.writeTxn(() async {
      await _plainTextNotes.where().deletedEqualTo(true).deleteAll();
      await _richTextNotes.where().deletedEqualTo(true).deleteAll();
      await _checklistNotes.where().deletedEqualTo(true).deleteAll();
    });

    _deleteAllIndexes(notes);
  }

  /// Deletes all the notes from the database.
  Future<void> clear() async {
    await _database.writeTxn(() async {
      await _plainTextNotes.clear();
      await _richTextNotes.clear();
      await _checklistNotes.clear();
    });

    _index.deleteAllDocuments();
  }
}
