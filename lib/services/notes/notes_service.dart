import 'package:collection/collection.dart';
import 'package:flutter_mimir/flutter_mimir.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/constants/environment.dart';
import 'package:localmaterialnotes/common/constants/labels.dart';
import 'package:localmaterialnotes/common/constants/notes.dart';
import 'package:localmaterialnotes/models/label/label.dart';
import 'package:localmaterialnotes/models/note/index/note_index.dart';
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

  late final MimirIndex _index;

  /// Ensures the notes service is initialized.
  Future<void> ensureInitialized() async {
    _index = DatabaseService().mimir.getIndex('notes');

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

  /// Returns all the notes.
  ///
  /// Returns the not deleted notes by default, or the deleted ones if [deleted] is set to `true`.
  Future<List<Note>> getAll({bool deleted = false}) async {
    return _notes.where().deletedEqualTo(deleted).findAll();
  }

  /// Returns all the notes containing the [label].
  Future<List<Note>> filterByLabel(Label label) async {
    final notes = await getAll();

    return notes.where((note) {
      // Load the list of labels of the note.
      note.labels.loadSync();

      return note.labels.contains(label);
    }).toList();
  }

  /// Returns all the notes that match the [search].
  ///
  /// If [notesPage] is set to `true`, the search should be performed on the deleted notes.
  ///
  /// If [label] is set, the search should be performed on the notes that have that label.
  Future<List<Note>> search(String search, bool notesPage, String? label) async {
    print(label);
    final searchFilter = Mimir.and(
      [
        Mimir.where('deleted', isEqualTo: (!notesPage).toString()),
        if (label != null) Mimir.where('labels', containsAtLeastOneOf: [label])
      ],
    );
    final searchResults = await _index.search(
      query: search,
      filter: searchFilter,
    );
    final notesIds = searchResults.map((Map<String, dynamic> noteIndex) {
      return noteIndex['id'] as int;
    }).toList();

    final notes = (await _notes.getAll(notesIds));
    final notesNotNull = notes.whereNotNull().toList();

    // Check that all search results correspond to an existing note
    if (notes.length != notesNotNull.length) {
      final cases = notes.length - notesNotNull.length;
      logger.w('Some notes search results have an ID that does not correspond to an existing note ($cases cases)');
    }

    return notesNotNull;
  }

  /// Puts the [note] in the database.
  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      await _notes.put(note);
    });

    final document = NoteIndex.fromNote(note).toJson();
    await _index.addDocument(document);
  }

  /// Puts the [notes] in the database.
  Future<void> putAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _notes.putAll(notes);
    });

    final documents = notes.map((note) {
      return NoteIndex.fromNote(note).toJson();
    }).toList();
    await _index.addDocuments(documents);
  }

  /// Updates the [notes] with their corresponding [notesLabels] in the database.
  Future<void> putAllLabels(List<Note> notes, List<List<Label>> notesLabels) async {
    assert(notes.length == notesLabels.length);

    await _database.writeTxn(() async {
      for (var i = 0; i < notes.length; i++) {
        final note = notes[i];
        final labels = notesLabels[i];

        await note.labels.reset();
        note.labels.addAll(labels);
        await note.labels.save();
      }
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

    await _index.deleteDocument(note.id.toString());
  }

  /// Deletes the [notes] from the database.
  Future<void> deleteAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _notes.deleteAll(notes.map((note) => note.id).toList());
    });

    final notesIds = notes.map((note) {
      return note.id.toString();
    }).toList();
    await _index.deleteDocuments(notesIds);
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
