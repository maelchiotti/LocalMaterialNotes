import 'package:isar/isar.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseManager {
  static final DatabaseManager _singleton = DatabaseManager._internal();

  factory DatabaseManager() {
    return _singleton;
  }

  DatabaseManager._internal();

  late Isar database;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    database = await Isar.open(
      [NoteSchema],
      directory: directory.path,
    );
  }

  Future<List<Note>> getAll({bool deleted = false}) async {
    final sortMethod = SortMethod.methodFromPreferences();
    final sortAscending = SortMethod.ascendingFromPreferences;

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
        throw Exception();
    }
  }

  Future<void> add(Note note) async {
    await database.writeTxn(() async {
      await database.notes.put(note);
    });
  }

  Future<void> edit(Note note) async {
    await add(note);
  }

  Future<void> delete(Id id) async {
    await database.writeTxn(() async {
      await database.notes.delete(id);
    });
  }

  Future<void> deleteAll() async {
    await database.writeTxn(() async {
      await database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }
}
