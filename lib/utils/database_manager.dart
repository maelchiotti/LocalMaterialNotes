import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/info_manager.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseManager {
  static final DatabaseManager _singleton = DatabaseManager._internal();

  factory DatabaseManager() {
    return _singleton;
  }

  DatabaseManager._internal();

  String databaseName = 'materialnotes';
  late String databaseDirectory;
  late Isar database;

  Future<void> init() async {
    databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    database = await Isar.open(
      [NoteSchema],
      name: databaseName,
      directory: databaseDirectory,
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

  Future<void> addAll(List<Note> notes) async {
    await database.writeTxn(() async {
      await database.notes.putAll(notes);
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

  Future<void> export() async {
    final exportDirectory = await FilePicker.platform.getDirectoryPath();

    if (exportDirectory == null) return;

    await _checkPermissions(exportDirectory);

    final timestamp = DateTime.timestamp();
    final exportFile = File('$exportDirectory/materialnotes_export_${timestamp.filename}.json');

    final notes = await database.notes.where().findAll();
    final notesJson = jsonEncode(notes);
    await exportFile.writeAsString(notesJson);
  }

  Future<void> import() async {
    final filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (filePickerResult == null || filePickerResult.count == 0) return;

    final importFilePath = filePickerResult.paths.first!;

    await _checkPermissions(importFilePath);

    final importFile = File(importFilePath);
    final notesJson = jsonDecode(await importFile.readAsString()) as List;
    final notes = notesJson.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();

    await addAll(notes);
  }

  Future<void> _checkPermissions(String filepath) async {
    // External storage requires permissions
    if (!filepath.startsWith('/storage/emulated')) {
      if (InfoManager().androidVersion > 33) {
        // Android 13 or above
        if (!(await Permission.manageExternalStorage.request()).isGranted) {
          throw Exception(localizations.error_access_external_storage_required);
        }
      } else {
        // Android 12 or below
        if (!(await Permission.storage.request()).isGranted) {
          throw Exception(localizations.error_access_external_storage_required);
        }
      }
    }
  }
}
