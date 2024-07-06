import 'dart:io';

import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';
import 'package:path_provider/path_provider.dart';

class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  factory AutoExportUtils() {
    return _singleton;
  }

  AutoExportUtils._internal();

  late Uri autoExportDirectory;

  final _downloadDirectoryPath = '/storage/emulated/0/Download';
  final _intermediateDirectories = ['Material Notes', 'backups'];

  Future<void> ensureInitialized() async {
    await _setAutoExportDirectory();

    await _performAutoExportIfNeeded();
  }

  Future<File> get getAutoExportFile async {
    return getExportFile(
      autoExportDirectory,
      'json',
      intermediateDirectories: _intermediateDirectories,
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

      autoExportDirectory = externalStorageDirectory.uri;
    }

    autoExportDirectory = downloadsDirectory.uri;
  }

  /// Perform an auto export of the database if it is needed.
  ///
  /// An auto export is needed if it is enabled, and if the time difference between now and the last auto export
  /// is greater than the auto export frequency chosen by the user.
  Future<void> _performAutoExportIfNeeded() async {
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>();

    // Auto export is disabled
    if (autoExportFrequency == 0) {
      return;
    }

    final now = DateTime.now();

    // If the last auto export date is null, set it to a very long time ago to force the export now
    final lastAutoExportDate = DateTime.tryParse(PreferenceKey.lastAutoExportDate.getPreferenceOrDefault()) ??
        now.subtract(const Duration(days: 365));
    final durationSinceLastAutoExport = now.difference(lastAutoExportDate);
    final autoExportFrequencyDuration = Duration(days: autoExportFrequency.toInt());

    // If no auto export has been done for longer than the defined auto export frequency,
    // then perform an auto export now
    if (durationSinceLastAutoExport > autoExportFrequencyDuration) {
      DatabaseUtils().autoExportAsJson();

      PreferencesUtils().set<String>(PreferenceKey.lastAutoExportDate.name, now.toIso8601String());
    }
  }
}
