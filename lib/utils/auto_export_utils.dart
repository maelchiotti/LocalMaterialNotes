import 'dart:io';

import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:localmaterialnotes/utils/files_utils.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:path_provider/path_provider.dart';

class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  factory AutoExportUtils() {
    return _singleton;
  }

  AutoExportUtils._internal();

  late Uri? autoExportDirectory;

  final _downloadDirectoryPath = '/storage/emulated/0/Download';
  final _intermediateDirectories = ['Material Notes', 'backups'];

  Future<void> ensureInitialized() async {
    await _setAutoExportDirectory();

    await _performAutoExportIfNeeded();
  }

  bool get hasAutoExportDirectory => autoExportDirectory != null;

  Future<File?> get getAutoExportFile async {
    if (!hasAutoExportDirectory) {
      return null;
    }

    final downloadDirectory = autoExportDirectory!;

    return getExportFile(
      downloadDirectory,
      'json',
      intermediateDirectories: _intermediateDirectories,
    );
  }

  Future<void> _setAutoExportDirectory() async {
    final downloadsDirectory = Directory(_downloadDirectoryPath);

    if (!downloadsDirectory.existsSync()) {
      final externalStorageDirectory = await getExternalStorageDirectory();

      autoExportDirectory = externalStorageDirectory?.uri;
    }

    autoExportDirectory = downloadsDirectory.uri;
  }

  Future<void> _performAutoExportIfNeeded() async {
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<double>();

    // Auto export is disabled
    if (autoExportFrequency == 0) {
      return;
    }

    // If the last auto export date is null, set it to now to force the export now
    final lastAutoExportDate =
        DateTime.tryParse(PreferenceKey.lastAutoExportDate.getPreferenceOrDefault()) ?? DateTime.now();

    // If no auto export has been done for longer than the defined auto export frequency,
    // then perform an auto export now
    final durationSinceLastAutoExport = DateTime.now().difference(lastAutoExportDate);
    final autoExportFrequencyDuration = Duration(days: autoExportFrequency.toInt());
    if (durationSinceLastAutoExport > autoExportFrequencyDuration) {
      DatabaseUtils().autoExportAsJson();
    }
  }
}
