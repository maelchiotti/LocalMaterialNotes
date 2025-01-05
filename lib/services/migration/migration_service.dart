import 'package:isar/isar.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import '../../models/deprecated/note.dart';
import '../../models/note/note.dart';
import '../database_service.dart';

/// Database migration service.
class MigrationService {
  final _databaseService = DatabaseService();

  /// Migrates the database to the latest version if needed.
  Future<void> migrateIfNeeded() async {
    final databaseVersion = PreferenceKey.databaseVersion.getPreferenceOrDefault();

    switch (databaseVersion) {
      case 1:
        await _migrateToV2();
    }
  }

  /// Migrates the database to version 2.
  ///
  /// Moves all legacy notes from the legacy `notes` collection to the new `richTextNotes` collection
  /// to allow adding different types of notes.
  Future<void> _migrateToV2() async {
    logger.i('Migrating the database from version 1 to version 2');

    final database = _databaseService.database;

    // Convert the legacy notes to rich text notes
    final legacyNotes = await database.notes.where().findAll();
    final richTextNotes = legacyNotes
        .map(
          (legacyNote) => RichTextNote(
            deleted: legacyNote.deleted,
            pinned: legacyNote.pinned,
            createdTime: legacyNote.createdTime,
            editedTime: legacyNote.editedTime,
            title: legacyNote.title,
            content: legacyNote.content,
          ),
        )
        .toList();

    // Add all the notes to the new collection
    var addedRichTextNotes = <int>[];
    await database.writeTxn(() async {
      addedRichTextNotes = await database.richTextNotes.putAll(richTextNotes);
    });

    // Check that the migration succeeded
    final legacyNotesCount = await database.notes.count();
    final addedRichTextNotesCount = addedRichTextNotes.length;
    assert(
      legacyNotesCount == addedRichTextNotesCount,
      'The count of legacy notes ($legacyNotesCount) is different from the count of rich text notes ($addedRichTextNotesCount) after the migration to v2',
    );

    // Remove all the legacy notes
    await database.writeTxn(() async {
      await database.notes.clear();
    });

    // Update the database version
    await PreferenceKey.databaseVersion.set(2);
  }
}
