import 'dart:io';

import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/extensions/uri_extension.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Utilities for the auto export functionality.
///
/// This class is a singleton.
class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  factory AutoExportUtils() {
    return _singleton;
  }

  AutoExportUtils._internal();

  /// Root directory where auto exports are located.
  late Uri _autoExportDirectory;

  /// Path to the default download directory on Android devices.
  final _downloadDirectoryPath = '/storage/emulated/0/Download';

  /// Subdirectories to add after the export path.
  final subDirectories = ['Material Notes', 'backups'];

  /// Precise directory where auto exports are located.
  ///
  /// It's a combination of [_autoExportDirectory] and [subDirectories].
  Uri get backupsDirectory {
    final backupsDirectoryPath = joinAll([_autoExportDirectory.path, ...subDirectories]);

    return Uri.directory(backupsDirectoryPath);
  }

  Future<void> ensureInitialized() async {
    await _setAutoExportDirectory();

    await performAutoExportIfNeeded();
  }

  /// Returns the JSON file in which to write the exported data.
  Future<File> get getAutoExportFile async {
    return getExportFile(
      backupsDirectory.toDecodedString,
      'json',
    );
  }

  /// Set the auto export directory.
  ///
  /// By default, the auto export directory is the Android's Download directory.
  /// If it doesn't exist, the application documents directory is used.
  Future<void> _setAutoExportDirectory() async {
    final downloadsDirectory = Directory(_downloadDirectoryPath);

    if (!downloadsDirectory.existsSync()) {
      final externalStorageDirectory = await getApplicationDocumentsDirectory();

      _autoExportDirectory = externalStorageDirectory.uri;
    }

    _autoExportDirectory = downloadsDirectory.uri;
  }

  /// Checks if an auto export should be performed.
  ///
  /// An auto export should be performed if it is enabled and either if:
  /// - no auto export has been performed yet
  /// - or the time difference between now and the last auto export is greater than the auto export frequency
  ///   chosen by the user
  bool _shouldPerformAutoExport() {
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>();

    // Auto export is disabled
    if (autoExportFrequency == 0) {
      return false;
    }

    final lastAutoExportDate = DateTime.tryParse(PreferenceKey.lastAutoExportDate.getPreferenceOrDefault());

    // If the last auto export date is null, perform the auto first auto export now
    if (lastAutoExportDate == null) {
      return true;
    }

    final durationSinceLastAutoExport = DateTime.now().difference(lastAutoExportDate);
    final autoExportFrequencyDuration = Duration(days: autoExportFrequency.toInt());

    // If no auto export has been done for longer than the defined auto export frequency,
    // then perform an auto export now
    return durationSinceLastAutoExport > autoExportFrequencyDuration;
  }

  /// Performs an auto export of the database if it is needed.
  Future<void> performAutoExportIfNeeded() async {
    if (!_shouldPerformAutoExport()) {
      return;
    }

    final encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
    final password = await PreferenceKey.autoExportPassword.getPreferenceOrDefaultSecure();

    DatabaseUtils().autoExportAsJson(encrypt, password);

    PreferencesUtils().set<String>(
      PreferenceKey.lastAutoExportDate.name,
      DateTime.now().toIso8601String(),
    );
  }
}
