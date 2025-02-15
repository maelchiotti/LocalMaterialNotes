import 'dart:developer';

import 'package:isar/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import '../../models/deprecated/note.dart';
import '../../models/note/note.dart';
import '../database_service.dart';
import '../notes/notes_service.dart';

/// Database migration service.
class MigrationService {
  final _databaseService = DatabaseService();
  final _notesService = NotesService();

  /// Migrates the database to the latest version if needed.
  Future<void> migrateIfNeeded() async {
    final databaseVersion = PreferenceKey.databaseVersion.getPreferenceOrDefault();

    switch (databaseVersion) {
      case 1:
        await _migrateToV2();
      case 2:
        await _migrateToV3();
    }
  }

  /// Migrates the database to version 2.
  ///
  /// Moves all legacy notes from the legacy `notes` collection to the new `richTextNotes` collection
  /// to allow adding different types of notes.
  Future<void> _migrateToV2() async {
    logger.i('Migrating the database from version 1 to version 2');

    // Get the old notes and their labels
    final oldNotes = await _databaseService.database.notes.where().findAll();
    final oldLabels = oldNotes.map((note) => note.labels.toList()).toList();

    // Convert the old notes to rich text notes
    final richTextNotes = oldNotes
        .map(
          (oldNote) => RichTextNote(
            archived: false,
            deleted: oldNote.deleted,
            pinned: oldNote.pinned,
            createdTime: oldNote.createdTime,
            editedTime: oldNote.editedTime,
            title: oldNote.title,
            content: oldNote.content,
          ),
        )
        .toList();

    // Add the new notes to the new collection with their labels
    await _notesService.putAll(richTextNotes);
    await _notesService.putAllLabels(richTextNotes, oldLabels);

    // Check that the migration succeeded
    final oldNotesCount = await _databaseService.database.notes.count();
    final addedRichTextNotesCount = richTextNotes.length;
    assert(
      oldNotesCount == addedRichTextNotesCount,
      'The count of old notes ($oldNotesCount) is different from the count of rich text notes ($addedRichTextNotesCount) after the migration to v2',
    );

    // Update the database version
    await PreferenceKey.databaseVersion.set(2);
  }

  /// Migrates the database to version 3.
  ///
  /// Sets the new `id` and `archived` fields of each rich text note.
  Future<void> _migrateToV3() async {
    logger.i('Migrating the database from version 2 to version 3');

    // Get the rich text notes
    final richTextNotes = await _databaseService.database.richTextNotes.where().findAll();
    log(richTextNotes.map((n) => n.toJson()).toString());

    // Set the rich text notes 'id' and 'archived' fields
    for (final note in richTextNotes) {
      note.id = uuid.v4();
      note.archived = false;
      await _notesService.put(note);
    }

    // Check that the migration succeeded
    final richTextNotesCount = await _databaseService.database.richTextNotes.count();
    final richTextNotesNotArchivedCount =
        await _databaseService.database.richTextNotes.where().archivedEqualTo(false).count();
    assert(
      richTextNotesCount == richTextNotesNotArchivedCount,
      'The count of rich text notes ($richTextNotesCount) is different from the count of not archived rich text notes ($richTextNotesNotArchivedCount) after the migration to v3',
    );

    // Update the database version
    await PreferenceKey.databaseVersion.set(3);
  }
}
