import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/constants/environment.dart';
import '../../common/constants/labels.dart';
import '../../common/constants/notes.dart';
import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../../models/note/note_status.dart';
import '../database_service.dart';
import 'notes_index_service.dart';

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

  late final NotesIndexService _indexesService;

  /// Ensures the notes service is initialized.
  Future<void> ensureInitialized() async {
    _database = DatabaseService().database;

    _plainTextNotes = DatabaseService().database.plainTextNotes;
    _markdownNotes = DatabaseService().database.markdownNotes;
    _richTextNotes = DatabaseService().database.richTextNotes;
    _checklistNotes = DatabaseService().database.checklistNotes;

    _indexesService = NotesIndexService();

    // Check that the notes are correctly indexed
    await _indexesService.checkIndexes();

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

  /// Returns all the notes with the [notesStatus] that match the [search].
  ///
  /// If [label] is set, the search should be performed on the notes that have that label.
  Future<List<Note>> search(String search, NoteStatus notesStatus, String? label) async {
    final searchFilter = Mimir.and([
      ...switch (notesStatus) {
        NoteStatus.available => [
          Mimir.where('deleted', isEqualTo: false.toString()),
          Mimir.where('archived', isEqualTo: false.toString()),
        ],
        NoteStatus.archived => [Mimir.where('archived', isEqualTo: (true).toString())],
        NoteStatus.deleted => [Mimir.where('deleted', isEqualTo: (true).toString())],
      },
      if (label != null) Mimir.where('labels', containsAtLeastOneOf: [label]),
    ]);

    final searchResults = await _indexesService.index.search(query: search, filter: searchFilter);

    final notesIds = searchResults.map((noteIndex) => noteIndex['id'] as int).toList();
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
        case final MarkdownNote _:
          await _markdownNotes.put(note);
        case final RichTextNote _:
          await _richTextNotes.put(note);
        case final ChecklistNote _:
          await _checklistNotes.put(note);
      }
    });

    await _indexesService.updateIndexes([note]);
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    final plainTextNotes = notes.whereType<PlainTextNote>().toList();
    final markdownNotes = notes.whereType<MarkdownNote>().toList();
    final richTextNotes = notes.whereType<RichTextNote>().toList();
    final checklistNotes = notes.whereType<ChecklistNote>().toList();

    await _database.writeTxn(() async {
      await _plainTextNotes.putAll(plainTextNotes);
      await _markdownNotes.putAll(markdownNotes);
      await _richTextNotes.putAll(richTextNotes);
      await _checklistNotes.putAll(checklistNotes);
    });

    await _indexesService.updateIndexes(notes);
  }

  /// Updates the [note] with the [labels] in the database.
  Future<void> putLabels(Note note, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      await note.labels.reset();
      note.labels.addAll(labels);
      await note.labels.save();
    });

    await _indexesService.updateIndexes([note]);
  }

  /// Updates the [note] with the added [labels] in the database.
  Future<void> addLabels(List<Note> notes, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      for (final note in notes) {
        note.labels.addAll(labels);
        await note.labels.save();
      }
    });

    await _indexesService.updateIndexes(notes);
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

    await _indexesService.updateIndexes(notes);
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

    await _indexesService.deleteIndexes([note]);
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

    await _indexesService.deleteIndexes(notes);
  }

  /// Deletes all the deleted notes from the database.
  Future<void> emptyBin() async {
    final notes = await getAllDeleted();

    await _database.writeTxn(() async {
      await _plainTextNotes.where().deletedEqualTo(true).deleteAll();
      await _markdownNotes.where().deletedEqualTo(true).deleteAll();
      await _richTextNotes.where().deletedEqualTo(true).deleteAll();
      await _checklistNotes.where().deletedEqualTo(true).deleteAll();
    });

    await _indexesService.deleteIndexes(notes);
  }

  /// Deletes all the notes from the database.
  Future<void> clear() async {
    await _database.writeTxn(() async {
      await _plainTextNotes.clear();
      await _markdownNotes.clear();
      await _richTextNotes.clear();
      await _checklistNotes.clear();
    });

    await _indexesService.index.deleteAllDocuments();
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
