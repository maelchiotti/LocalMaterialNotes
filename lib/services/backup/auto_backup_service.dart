import 'dart:developer';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saf_util/saf_util.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import '../../utils/files_utils.dart';
import 'backup_service.dart';

/// Service for the automatic backup (export and import) of the database.
///
/// This class is a singleton.
class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  /// Default constructor.
  factory AutoExportUtils() => _singleton;

  AutoExportUtils._internal();

  final _safUtil = SafUtil();

  /// Directory where automatic exports are saved.
  late String autoExportDirectory;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    await setAutoExportDirectory();
    await performAutoExportIfNeeded();
  }

  /// Sets the directory where automatic exports are located depending on the user preference and the available
  /// permissions.
  Future<void> setAutoExportDirectory() async {
    final autoExportDirectoryPreference = PreferenceKey.autoExportDirectory.getPreferenceOrDefault();

    // Set to default if the user didn't choose a directory
    if (autoExportDirectoryPreference.isEmpty) {
      return setAutoExportDirectoryToDefault();
    }

    final autoExportDirectorySaf = await _safUtil.documentFileFromUri(autoExportDirectoryPreference, true);

    // Set to default if the directory doesn't exist
    try {
      if (autoExportDirectorySaf == null || !(await doesDirectoryExist(autoExportDirectorySaf.uri))) {
        return setAutoExportDirectoryToDefault();
      }
    } catch (exception, stackTrace) {
      logger.e(exception.toString(), exception, stackTrace);

      // URIs for SAF used before v1.7.1 are not compatible and need to be discarded
      log("[Auto export] Discarding an URI in the old format for the SAF auto export directory.");
      await PreferenceKey.autoExportDirectory.remove();

      return setAutoExportDirectoryToDefault();
    }

    autoExportDirectory = autoExportDirectorySaf.uri;
  }

  /// Sets the automatic export directory to its default value.
  ///
  /// The default automatic export directory is the downloads directory,
  /// or the application documents directory if it does not exist.
  Future<void> setAutoExportDirectoryToDefault() async {
    autoExportDirectory = await autoExportDirectoryDefault;

    await createDirectory(autoExportDirectory);
  }

  /// Returns the default automatic export directory.
  Future<String> get autoExportDirectoryDefault async {
    final baseDirectory = (await getApplicationDocumentsDirectory()).path;

    return join(baseDirectory, 'backups');
  }

  /// Checks if an automatic export should be performed.
  ///
  /// An automatic export should be performed if it is enabled and either if no automatic export has been performed yet,
  /// or the time difference between now and the last automatic export is greater than the automatic export frequency
  /// chosen by the user
  bool _shouldPerformAutoExport() {
    final enableAutoExport = PreferenceKey.enableAutoExport.getPreferenceOrDefault();
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault();

    if (!enableAutoExport) {
      return false;
    }

    final lastAutoExportDatePreference = PreferenceKey.lastAutoExportDate.getPreferenceOrDefault();
    final lastAutoExportDate = DateTime.tryParse(lastAutoExportDatePreference);

    // If the last automatic export date is null, perform the auto first automatic export now
    if (lastAutoExportDate == null) {
      return true;
    }

    final durationSinceLastAutoExport = DateTime.now().difference(lastAutoExportDate);
    final autoExportFrequencyDuration = Duration(days: autoExportFrequency);

    // If no automatic export has been done for longer than the defined automatic export frequency,
    // then perform an automatic export now
    return durationSinceLastAutoExport > autoExportFrequencyDuration;
  }

  /// Performs an automatic export of the database if it is needed.
  Future<void> performAutoExportIfNeeded() async {
    if (!_shouldPerformAutoExport()) {
      return;
    }

    final encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault();
    final password = await PreferenceKey.autoExportPassword.getPreferenceOrDefaultSecure();

    ManualBackupService().autoExportAsJson(encrypt, password);

    PreferenceKey.lastAutoExportDate.set(DateTime.now().toIso8601String());
  }
}
