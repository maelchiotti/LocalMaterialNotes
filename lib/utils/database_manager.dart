import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/info_manager.dart';
import 'package:localmaterialnotes/utils/locale_manager.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DatabaseManager {
  static final DatabaseManager _singleton = DatabaseManager._internal();

  factory DatabaseManager() {
    return _singleton;
  }

  DatabaseManager._internal();

  final _databaseName = 'materialnotes';
  late String _databaseDirectory;
  late Isar _database;

  Future<void> init() async {
    _databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    _database = await Isar.open(
      [NoteSchema],
      name: _databaseName,
      directory: _databaseDirectory,
    );

    if (await IsFirstRun.isFirstCall()) {
      await add(_welcomeNote);
    }
  }

  Future<List<Note>> getAll({bool deleted = false}) async {
    final sortMethod = SortMethod.methodFromPreferences();
    final sortAscending = SortMethod.ascendingFromPreferences;

    final sortedByPinned = _database.notes.where().deletedEqualTo(deleted).sortByPinnedDesc();

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
    await _database.writeTxn(() async {
      await _database.notes.put(note);
    });
  }

  Future<void> addAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.putAll(notes);
    });
  }

  Future<void> edit(Note note) async {
    await add(note);
  }

  Future<void> delete(Id id) async {
    await _database.writeTxn(() async {
      await _database.notes.delete(id);
    });
  }

  Future<void> deleteAll() async {
    await _database.writeTxn(() async {
      await _database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  Future<void> export() async {
    final exportDirectory = await FilePicker.platform.getDirectoryPath();

    if (exportDirectory == null) return;

    await _checkPermissions(exportDirectory);

    final timestamp = DateTime.timestamp();
    final exportFile = File('$exportDirectory/materialnotes_export_${timestamp.filename}.json');

    final notes = await _database.notes.where().findAll();
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

  Note get _welcomeNote {
    final locale = LocaleManager().locale;

    final String title;
    final String content;

    if (locale == const Locale('en')) {
      title = 'Welcome to Material Notes!';
      content = 'Simple, local, material design notes';
    } else if (locale == const Locale('fr')) {
      title = 'Bienvenue dans Material Notes !';
      content = 'Notes simples, locales, en material design';
    } else {
      throw Exception('Missing welcome note for locale: $locale');
    }

    return Note(
      id: uuid.v4(),
      deleted: false,
      pinned: true,
      createdTime: DateTime.now(),
      editedTime: DateTime.now(),
      title: title,
      content: '[{"insert":"$content\\n\\n"}]',
    );
  }
}
