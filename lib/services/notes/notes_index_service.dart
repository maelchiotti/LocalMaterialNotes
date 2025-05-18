import 'package:collection/collection.dart';
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
  }

  /// Checks that each note has an index. If not, rebuilds the indexes.
  Future<void> checkIndexes() async {
    final notes = await _notesService.getAll();
    final indexes = await index.getAllDocuments();

    final notesIds = notes.map((note) => note.isarId).toList();
    final indexesIds = indexes.map((index) => index['id'] as int).toList();

    if (!notesIds.equals(indexesIds)) {
      logger.i('Re-indexing all notes');

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
