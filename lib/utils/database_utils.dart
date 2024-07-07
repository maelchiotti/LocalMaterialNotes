import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:is_first_run/is_first_run.dart';
import 'package:isar/isar.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/encryption_utils.dart';
import 'package:localmaterialnotes/utils/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/sort_method.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

class DatabaseUtils {
  static final DatabaseUtils _singleton = DatabaseUtils._internal();

  factory DatabaseUtils() {
    return _singleton;
  }

  DatabaseUtils._internal();

  final _databaseName = 'materialnotes';
  late String _databaseDirectory;
  late Isar _database;

  Future<void> ensureInitialized() async {
    _databaseDirectory = (await getApplicationDocumentsDirectory()).path;
    _database = await Isar.open(
      [NoteSchema],
      name: _databaseName,
      directory: _databaseDirectory,
    );

    if (await IsFirstRun.isFirstCall()) {
      await put(Note.welcome());
    }
  }

  Future<List<Note>> getAll({bool? deleted}) async {
    final sortMethod = SortMethod.fromPreference();
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
        throw Exception('The sort methode is not set: $sortMethod');
    }
  }

  Future<void> put(Note note) async {
    await _database.writeTxn(() async {
      await _database.notes.put(note);
    });
  }

  Future<void> putAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.putAll(notes);
    });
  }

  Future<void> delete(Note note) async {
    await _database.writeTxn(() async {
      await _database.notes.delete(note.id);
    });
  }

  Future<void> deleteAll(List<Note> notes) async {
    await _database.writeTxn(() async {
      await _database.notes.deleteAll(notes.map((note) => note.id).toList());
    });
  }

  Future<void> emptyBin() async {
    await _database.writeTxn(() async {
      await _database.notes.where().deletedEqualTo(true).deleteAll();
    });
  }

  Future<bool> isBinEmpty() async {
    return await _database.notes.where().deletedEqualTo(true).isEmpty();
  }

  Future<bool> exportAsJson({bool encrypt = false, String passphrase = ''}) async {
    final exportDirectory = await pickDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final notes = await getAll();

    if (encrypt && passphrase.isNotEmpty) {
      for (final note in notes) {
        note.title = EncryptionUtils().encrypt(passphrase, note.title);
        note.content = EncryptionUtils().encrypt(passphrase, note.content);
      }
    }

    final notesAsJson = jsonEncode(notes);
    final exportData = {
      'encrypted': encrypt,
      'notes': notesAsJson,
    };

    final file = getExportFile(exportDirectory, 'json');

    return await writeStringToFile(file, exportData.toString());
  }

  Future<bool> exportAsMarkdown() async {
    final exportDirectory = await pickDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final notes = await getAll();
    final archive = Archive();

    for (final note in notes) {
      final bytes = Uint8List.fromList(utf8.encode(note.markdown));
      final filename = sanitizeFilename('${note.title} (${note.createdTime.filename}).md');

      archive.addFile(ArchiveFile(filename, bytes.length, bytes));
    }

    final encodedArchive = ZipEncoder().encode(archive);

    if (encodedArchive == null) {
      return false;
    }

    final file = getExportFile(exportDirectory, 'zip');

    return await writeBytesToFile(file, encodedArchive);
  }

  Future<bool> autoExportAsJson() async {
    final notes = await getAll();
    final notesAsJson = jsonEncode(notes);

    final file = await AutoExportUtils().getAutoExportFile;

    return await writeStringToFile(file, notesAsJson);
  }

  Future<bool> import() async {
    final importPlatformFile = await pickSingleFile(
      FileType.custom,
      ['json'],
    );

    if (importPlatformFile == null || importPlatformFile.path == null) {
      return false;
    }

    if (importPlatformFile.path == null) {
      log('Failed to pick the file for the JSON import.');

      return false;
    }

    final importFile = File(importPlatformFile.path!);
    final importedString = importFile.readAsStringSync();

    final notesJson = jsonDecode(importedString) as List;
    final notes = notesJson.map((e) {
      return Note.fromJson(e as Map<String, dynamic>);
    }).toList();

    await putAll(notes);

    return true;
  }
}
