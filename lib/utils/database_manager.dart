import 'dart:convert';
import 'dart:typed_data';

import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/l10n/hardcoded_localizations.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_storage/shared_storage.dart' as saf;

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
      await add(welcomeNote);
    }
  }

  Future<List<Note>> getAll({bool? deleted}) async {
    final sortMethod = PreferenceKey.sortMethod.getPreferenceOrDefault<SortMethod>();
    final sortAscending = PreferenceKey.sortAscending.getPreferenceOrDefault<bool>();

    final sortedByPinned = deleted == null
        ? _database.notes.where().sortByPinnedDesc()
        : _database.notes.where().deletedEqualTo(deleted).sortByPinnedDesc();

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

  Future<bool> exportAsJson() async {
    final notes = await getAll();
    final notesAsJson = jsonEncode(notes);

    return await _export('application/json', 'json', notesAsJson);
  }

  Future<bool> exportAsMarkdown() async {
    final notes = await getAll();
    final StringBuffer notesAsMarkdown = StringBuffer('# Material Notes\n\n');
    for (final note in notes) {
      notesAsMarkdown
          .writeln('## ${note.title}${note.contentDisplay.isNotEmpty ? '\n\n' : ''}${note.contentDisplay}\n');
    }

    return await _export('text/markdown', 'md', notesAsMarkdown.toString().trim());
  }

  Future<bool> _export(String mimeType, String extension, String notesAsString) async {
    final exportDirectory = await saf.openDocumentTree();

    if (exportDirectory == null) {
      return false;
    }

    final timestamp = DateTime.timestamp();

    await saf.createFile(
      exportDirectory,
      mimeType: mimeType,
      displayName: 'materialnotes_export_${timestamp.filename}.$extension',
      bytes: Uint8List.fromList(utf8.encode(notesAsString)),
    );

    return true;
  }

  Future<bool> import() async {
    final importFiles = await saf.openDocument(
      grantWritePermission: false,
      mimeType: 'application/json',
    );

    if (importFiles == null || importFiles.isEmpty) {
      return false;
    }

    final importedData = await saf.getDocumentContent(importFiles.first);

    if (importedData == null) {
      throw Exception(localizations.error_read_file);
    }

    final importedString = utf8.decode(importedData);
    final notesJson = jsonDecode(importedString) as List;
    final notes = notesJson.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();

    await addAll(notes);

    return true;
  }
}
