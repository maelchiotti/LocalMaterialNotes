import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:dart_helper_utils/dart_helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:sanitize_filename/sanitize_filename.dart';

import '../../common/constants/constants.dart';
import '../../common/enums/mime_type.dart';
import '../../common/extensions/build_context_extension.dart';
import '../../common/extensions/date_time_extensions.dart';
import '../../common/extensions/iterable_extension.dart';
import '../../common/files/files_utils.dart';
import '../../common/preferences/preference_key.dart';
import '../../common/preferences/preferences_wrapper.dart';
import '../../common/system_utils.dart';
import '../../common/ui/snack_bar_utils.dart';
import '../../models/label/label.dart';
import '../../models/note/note.dart';
import '../../models/note/types/note_type.dart';
import '../../pages/settings/dialogs/auto_export_password_dialog.dart';
import '../labels/labels_service.dart';
import '../notes/notes_service.dart';
import 'auto_backup_service.dart';

/// Service for the manual backup (export and import) of the database.
class ManualBackupService {
  final _notesService = NotesService();
  final _labelsService = LabelsService();

  /// Returns the file name of the export file depending of the current date and time and its [extension].
  String _exportFileName(String extension) {
    final timestamp = DateTime.timestamp().filename;

    return 'materialnotes_export_$timestamp.$extension';
  }

  /// Imports all the notes from a JSON file picked by the user and returns whether the import was successful.
  Future<bool> import(BuildContext context) async {
    final importedFile = await selectAndReadFile(MimeType.json.value);

    if (importedFile == null) {
      return false;
    }

    var importedJson = jsonDecode(utf8.decode(importedFile));

    // If the imported JSON is just a list, it's an export from before v1. that just contains the notes list
    if (importedJson is List) {
      logger.w('The imported JSON file uses the old discontinued format with just the list of notes');

      return false;
    }

    importedJson = importedJson as Map<String, dynamic>;

    // Import the labels
    final importLabels = importedJson.containsKey("labels") && importedJson.getList<dynamic>("labels").isNotEmpty;
    if (importLabels) {
      final labelsAsJson = importedJson.getList<dynamic>("labels");
      final importedLabels = await _importLabels(labelsAsJson);
      if (!importedLabels) {
        return false;
      }
    }

    if (!context.mounted) {
      return false;
    }

    // Import the notes
    final notesAsJson = importedJson.getList<dynamic>("notes");
    final encrypted = importedJson.tryGetBool("encrypted") ?? false;
    final importedNotes = await _importNotes(context, notesAsJson, encrypted, importLabels);
    if (!importedNotes) {
      return false;
    }

    // Import the preferences
    final importPreferences = importedJson.containsKey("preferences");
    if (importPreferences) {
      final importedPreferences = await _importPreferences(importedJson);
      if (!importedPreferences) {
        return false;
      }
    }

    return true;
  }

  Future<bool> _importLabels(List<dynamic> labelsAsJson) async {
    final labels = labelsAsJson.map((labelAsJson) => Label.fromJson(labelAsJson)).toList();

    await _labelsService.putAllNew(labels);

    return true;
  }

  Future<bool> _importNotes(BuildContext context, List<dynamic> notesAsJson, bool encrypted, bool importLabels) async {
    List<Note> notes = [];
    List<List<Label>> notesLabels = [];

    if (encrypted && context.mounted) {
      final password = await showAdaptiveDialog<String>(
        context: context,
        useRootNavigator: false,
        builder: (context) => AutoExportPasswordDialog(
          title: context.l.settings_import,
          description: context.l.dialog_import_encryption_password_description,
        ),
      );

      if (password == null) {
        return false;
      }

      try {
        for (final noteAsJsonEncrypted in notesAsJson) {
          final noteType = NoteType.values.byNameOrNull(noteAsJsonEncrypted['type']);

          // If the note type is null, it's an export from before v2.0.0 when only rich text notes were available
          if (noteType == null) {
            notes.add(RichTextNote.fromJsonEncrypted(noteAsJsonEncrypted, password));
          } else {
            switch (noteType) {
              case NoteType.plainText:
                notes.add(PlainTextNote.fromJsonEncrypted(noteAsJsonEncrypted, password));
              case NoteType.markdown:
                notes.add(MarkdownNote.fromJsonEncrypted(noteAsJsonEncrypted, password));
              case NoteType.richText:
                notes.add(RichTextNote.fromJsonEncrypted(noteAsJsonEncrypted, password));
              case NoteType.checklist:
                notes.add(ChecklistNote.fromJsonEncrypted(noteAsJsonEncrypted, password));
            }
          }
        }
      } catch (exception, stackTrace) {
        logger.e(exception.toString(), exception, stackTrace);

        if (context.mounted) {
          SnackBarUtils().show(context, text: context.l.dialog_import_encryption_password_error);
        }

        return false;
      }
    } else {
      for (final noteAsJson in notesAsJson) {
        final noteType = NoteType.values.byNameOrNull(noteAsJson['type']);

        // If the note type is null, it's an export from before v2.0.0 when only rich text notes were available
        if (noteType == null) {
          notes.add(RichTextNote.fromJson(noteAsJson));
        } else {
          switch (noteType) {
            case NoteType.plainText:
              notes.add(PlainTextNote.fromJson(noteAsJson));
            case NoteType.markdown:
              notes.add(MarkdownNote.fromJson(noteAsJson));
            case NoteType.richText:
              notes.add(RichTextNote.fromJson(noteAsJson));
            case NoteType.checklist:
              notes.add(ChecklistNote.fromJson(noteAsJson));
          }
        }
      }
    }

    // Handle notes labels
    if (importLabels) {
      List<Label> databaseLabels = await _labelsService.getAll();

      for (final noteAsJson in notesAsJson) {
        final labelsString = noteAsJson['labels'] as List;
        final labels = databaseLabels.where((label) => labelsString.contains(label.name)).toList();

        notesLabels.add(labels);
      }
    }

    // Add notes and labels to the database
    await _notesService.putAll(notes);
    if (importLabels) {
      await _notesService.putAllLabels(notes, notesLabels);
    }

    return true;
  }

  Future<bool> _importPreferences(dynamic importedJson) async {
    final preferencesAndValues = importedJson['preferences'] as Map<String, dynamic>;

    preferencesAndValues.forEach((preference, value) {
      final preferenceKey = PreferenceKey.values.byNameOrNull(preference);

      if (preferenceKey == null) {
        logger.w("While restoring the preferences from JSON, the preference '$preference' doesn't exist");
      } else {
        if (preferenceKey.backup) {
          // If the preference value is a list, then it's a list of String
          // (the only type of list that can be stored in the preferences)
          if (value is List) {
            preferenceKey.set(value.cast<String>());
          } else {
            preferenceKey.set(value);
          }
        }
      }
    });

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
    final version = SystemUtils().appVersion;
    final buildNumber = SystemUtils().buildNumber;

    var notes = await _notesService.getAll();
    if (encrypt && password != null && password.isNotEmpty) {
      notes = notes.map((note) => note.encrypted(password)).toList();
    }

    final labels = await _labelsService.getAll();

    final preferences = PreferencesWrapper().toJson();

    final exportData = {
      'version': version,
      'build_number': buildNumber,
      'encrypted': encrypt,
      'notes': notes,
      'labels': labels,
      'preferences': preferences,
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
      final markdown = '${note.labelsAsMarkdown}\n\n${note.contentAsMarkdown}';
      final bytes = utf8.encode(markdown);

      final filenameWithoutExtension = '${note.title} (${note.createdTime.filename})'.trim();
      final filenameWithoutExtensionSanitized = sanitizeFilename(filenameWithoutExtension);

      final folder = note.status.title;

      final filename = '$folder/$filenameWithoutExtensionSanitized.${MimeType.markdown.extension}';

      archive.addFile(ArchiveFile(filename, bytes.length, bytes));
    }

    final encodedArchive = ZipEncoder().encode(archive);

    return await writeFile(
      directory: exportDirectory,
      fileName: _exportFileName(MimeType.zip.extension),
      mimeType: MimeType.zip.value,
      data: Uint8List.fromList(encodedArchive),
    );
  }
}
