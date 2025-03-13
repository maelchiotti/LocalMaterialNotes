import 'package:flutter_mimir/flutter_mimir.dart';

import '../../common/constants/constants.dart';
import '../../models/note/index/note_index.dart';
import '../../models/note/note.dart';
import '../database_service.dart';
import 'notes_service.dart';

/// Notes index service.
///
/// This class is a singleton.
class NotesIndexService {
  static final NotesIndexService _singleton = NotesIndexService._internal();

  /// Notes index service.
  factory NotesIndexService() => _singleton;

  NotesIndexService._internal();

  /// Notes index.
  late final MimirIndex index;

  /// Notes service.
  late final NotesService _notesService;

  /// Ensures the indexes service is initialized.
  Future<void> ensureInitialized() async {
    index = await DatabaseService().mimir.openIndex('notes', primaryKey: 'id', searchableFields: ['title', 'content']);

    _notesService = NotesService();

    // If the number of indexed notes is different from the total number of notes, re-index them all
    // (this should only be needed on the first launch after updating from a version that didn't have the index feature)
    final indexNotesCount = (await index.numberOfDocuments).toInt();
    final notesCount = await _notesService.count;
    if (indexNotesCount != notesCount) {
      logger.i('Re-indexing all notes ($indexNotesCount notes were indexed out of $notesCount)');

      await clearIndexes();
      await updateIndexes(await _notesService.getAll());
    }
  }

  /// Updates the indexes of the [notes].
  Future<void> updateIndexes(List<Note> notes) async {
    final documents = notes.map((note) => NoteIndex.fromNote(note).toJson()).toList();
    await index.addDocuments(documents);
  }

  /// Deletes the indexes of the [notes].
  Future<void> deleteIndexes(List<Note> notes) async {
    final notesIds = notes.map((note) => note.id).toList();
    await index.deleteDocuments(notesIds);
  }

  /// Deletes all the indexes.
  Future<void> clearIndexes() async {
    await index.deleteAllDocuments();
  }
}
