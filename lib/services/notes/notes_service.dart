import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/common/constants/environment.dart';
import 'package:localmaterialnotes/common/constants/notes.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/services/database_service.dart';

/// Service for the notes database.
///
/// This class is a singleton.
class NotesService {
  static final NotesService _singleton = NotesService._internal();

  /// Default constructor.
  factory NotesService() {
    return _singleton;
  }

  NotesService._internal();

  final Isar _database = DatabaseService().database;
  final _notes = DatabaseService().database.notes;

  /// Ensures the notes service is initialized.
  Future<void> ensureInitialized() async {
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
    return _notes.where().deletedEqualTo(deleted).findAll();
  }

  /// Returns all the notes containing the [label].
  Future<List<Note>> getAllFilteredByLabel(Label label) async {
    final notes = await getAll();

    return notes.where((note) {
      // Load the list of labels of the note.
      note.labels.loadSync();

      return note.labels.contains(label);
    }).toList();
  }

  /// Puts the [note] in the database.
  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      await _notes.put(note);
    });
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _notes.putAll(notes);
    });
  }

  /// Updates the [note] with the [labels] in the database.
  Future<void> putLabels(Note note, Iterable<Label> labels) async {
    await _database.writeTxn(() async {
      await note.labels.reset();

      note.labels.addAll(labels);

      await note.labels.save();
    });
  }

  /// Deletes the [note] from the database.
  Future<void> delete(Note note) async {
    await _database.writeTxn(() async {
      await _notes.delete(note.id);
    });
  }

  /// Deletes the [notes] from the database.
  Future<void> deleteAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _notes.deleteAll(notes.map((note) => note.id).toList());
    });
  }

  /// Deletes all the deleted notes from the database.
  Future<void> emptyBin() async {
    await _database.writeTxn(() async {
      await _notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  /// Deletes all the notes from the database.
  Future<void> clear() async {
    await _database.writeTxn(() async {
      await _notes.where().deleteAll();
    });
  }
}
