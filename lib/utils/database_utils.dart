import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/common/enums/mime_type.dart';
import 'package:localmaterialnotes/common/extensions/date_time_extensions.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/pages/settings/dialogs/auto_export_password_dialog.dart';
import 'package:localmaterialnotes/services/notes/notes_service.dart';
import 'package:localmaterialnotes/utils/auto_export_utils.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/info_utils.dart';
import 'package:localmaterialnotes/utils/logs_utils.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

/// Utilities for the database.
///
/// This class is a singleton.
class DatabaseUtils {
  final _notesService = NotesService();

  /// Returns the file name of the export file depending of the current date and time and its [extension].
  String _exportFileName(String extension) {
    final timestamp = DateTime.timestamp().filename;

    return 'materialnotes_export_$timestamp.$extension';
  }

  /// Imports all the notes from a JSON file picked by the user.
  Future<bool> import(BuildContext context) async {
    final importFile = await selectFile(jsonTypeGroup);

    if (importFile == null) {
      return false;
    }

    final importedString = await importFile.readAsString();
    var importedJson = jsonDecode(utf8.decode(importedString.codeUnits));

    List<Note>? notes;

    // If the imported JSON is just a list, then it's the old export format (before v1.5.0) that just contains
    // the notes list. Otherwise, it's the new export format (after v1.5.0) that contains other data.
    if (importedJson is List) {
      notes = importedJson.map((noteAsJson) {
        return Note.fromJson(noteAsJson as Map<String, dynamic>);
      }).toList();
    } else {
      importedJson = importedJson as Map<String, dynamic>;

      final encrypted = importedJson['encrypted'] as bool;
      final notesAsJson = importedJson['notes'] as List;

      if (encrypted && context.mounted) {
        final password = await showAdaptiveDialog<String>(
          context: context,
          useRootNavigator: false,
          builder: (context) => AutoExportPasswordDialog(
            title: l.settings_import,
            description: l.dialog_import_encryption_password_description,
          ),
        );

        if (password == null) {
          return false;
        }

        try {
          notes = notesAsJson.map((noteAsJsonEncrypted) {
            return Note.fromJsonEncrypted(
              noteAsJsonEncrypted as Map<String, dynamic>,
              password,
            );
          }).toList();
        } catch (exception, stackTrace) {
          LogsUtils().handleException(exception, stackTrace);

          SnackBarUtils.error(
            l.dialog_import_encryption_password_error,
            duration: const Duration(seconds: 8),
          ).show();

          return false;
        }
      } else {
        notes = notesAsJson.map((noteAsJson) {
          return Note.fromJson(noteAsJson as Map<String, dynamic>);
        }).toList();
      }
    }

    await _notesService.putAll(notes);

    return true;
  }

  /// Exports all the notes in a JSON file with the [fileName] in the [directory].
  ///
  /// If [encrypt] is enabled, the title and the content of the notes is encrypted with the [password].
  Future<bool> _exportAsJson({
    required bool encrypt,
    required String? password,
    required String directory,
    required String fileName,
  }) async {
    var notes = await _notesService.getAll();

    if (encrypt && password != null && password.isNotEmpty) {
      notes = notes.map((note) => note.encrypted(password)).toList();
    }

    final version = InfoUtils().appVersion;

    final exportData = {
      'version': version,
      'encrypted': encrypt,
      'notes': notes,
    };
    final exportDataAsJson = utf8.encode(jsonEncode(exportData));

    return await writeFile(
      directory: directory,
      fileName: fileName,
      mimeType: MimeType.json.value,
      data: exportDataAsJson,
    );
  }

  /// Automatically exports all the notes in a JSON file.
  ///
  /// If [encrypt] is enabled, the title and the content of the notes is encrypted with the [password].
  Future<bool> autoExportAsJson(bool encrypt, String password) async {
    return await _exportAsJson(
      encrypt: encrypt,
      password: password,
      directory: AutoExportUtils().autoExportDirectory,
      fileName: _exportFileName(MimeType.json.extension),
    );
  }

  /// Manually exports all the notes in a JSON file.
  ///
  /// First asks the user to pick a directory where to save the export file.
  ///
  /// If [encrypt] is enabled, the title and the content of the notes is encrypted with the [password].
  Future<bool> manuallyExportAsJson({required bool encrypt, String? password}) async {
    final exportDirectory = await selectDirectory();

    if (exportDirectory == null) {
      return false;
    }

    return await _exportAsJson(
      encrypt: encrypt,
      password: password,
      directory: exportDirectory,
      fileName: _exportFileName(MimeType.json.extension),
    );
  }

  /// Exports all the notes separately in Markdown files, stored in a ZIP archive.
  ///
  /// First asks the user to pick a directory where to save the export file.
  Future<bool> exportAsMarkdown() async {
    final exportDirectory = await selectDirectory();

    if (exportDirectory == null) {
      return false;
    }

    final notes = await _notesService.getAll();
    final archive = Archive();

    for (final note in notes) {
      final bytes = utf8.encode(note.markdown);
      final filenameWithoutExtension = '${note.title} (${note.createdTime.filename})';
      final filenameWithoutExtensionSanitized = sanitizeFilename(filenameWithoutExtension);
      final filename = '$filenameWithoutExtensionSanitized.${MimeType.markdown.extension}';

      archive.addFile(ArchiveFile(filename, bytes.length, bytes));
    }

    final encodedArchive = ZipEncoder().encode(archive);

    if (encodedArchive == null) {
      return false;
    }

    return await writeFile(
      directory: exportDirectory,
      fileName: _exportFileName(MimeType.zip.extension),
      mimeType: MimeType.zip.value,
      data: Uint8List.fromList(encodedArchive),
    );
  }
}
