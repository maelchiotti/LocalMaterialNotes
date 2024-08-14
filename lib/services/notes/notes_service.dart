import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/common/constants/environment.dart';
import 'package:localmaterialnotes/common/constants/notes.dart';
import 'package:localmaterialnotes/common/preferences/enums/sort_method.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/services/database_service.dart';
import 'package:path_provider/path_provider.dart';

/// Service for the notes database.
///
/// This class is a singleton.
class NotesService extends DatabaseService {
  static final NotesService _singleton = NotesService._internal();

  factory NotesService() {
    return _singleton;
  }

  NotesService._internal();

  @override
  late final String databaseDirectory;

  @override
  late final Isar database;

  /// Ensures the notes service is initialized.
  @override
  Future<void> ensureInitialized() async {
    databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    database = await Isar.open(
      [NoteSchema],
      name: databaseName,
      directory: databaseDirectory,
    );

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
    }

    // If the app runs for the first time ever, add the welcome note
    else if (await IsFirstRun.isFirstCall()) {
      await put(welcomeNote);
    }
  }

  /// Returns all the notes.
  ///
  /// Returns the not deleted notes by default, or the deleted ones if [deleted] is set to `true`.
  Future<List<Note>> getAll({bool deleted = false}) async {
    final sortMethod = SortMethod.fromPreference();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

    final sortedByPinned = database.notes.where().deletedEqualTo(deleted).sortByPinnedDesc();

    switch (sortMethod) {
      case SortMethod.date:
        return sortAscending
            ? await sortedByPinned.thenByEditedTime().findAll()
            : await sortedByPinned.thenByEditedTimeDesc().findAll();
      case SortMethod.title:
        return sortAscending
            ? await sortedByPinned.thenByTitle().findAll()
            : await sortedByPinned.thenByTitleDesc().findAll();
      default:
        throw Exception('The sort methode is not set: $sortMethod');
    }
  }

  /// Puts the [note] in the database.
  Future<void> put(Note note) async {
    await database.writeTxn(() async {
      await database.notes.put(note);
    });
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    await database.writeTxn(() async {
      await database.notes.putAll(notes);
    });
  }

  /// Deletes the [note] from the database.
  Future<void> delete(Note note) async {
    await database.writeTxn(() async {
      await database.notes.delete(note.id);
    });
  }

  /// Deletes the [notes] from the database.
  Future<void> deleteAll(List<Note> notes) async {
    await database.writeTxn(() async {
      await database.notes.deleteAll(notes.map((note) => note.id).toList());
    });
  }

  /// Deletes all the deleted notes from the database.
  Future<void> emptyBin() async {
    await database.writeTxn(() async {
      await database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  /// Deletes all the notes from the database.
  Future<void> clear() async {
    await database.writeTxn(() async {
      await database.notes.where().deleteAll();
    });
  }
}
