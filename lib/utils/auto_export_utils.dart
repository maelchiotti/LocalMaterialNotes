import 'package:collection/collection.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_storage/shared_storage.dart' as saf;

/// Utilities for the auto export functionality.
///
/// This class is a singleton.
class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  factory AutoExportUtils() {
    return _singleton;
  }

  AutoExportUtils._internal();

  /// Directory where auto exports are saved.
  late Uri autoExportDirectory;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    await setAutoExportDirectory();
    await performAutoExportIfNeeded();
  }

  /// Sets the directory where auto exports are located depending on the user preference and the available permissions.
  Future<void> setAutoExportDirectory() async {
    final autoExportDirectoryPreference = PreferenceKey.autoExportDirectory.getPreferenceOrDefault<String>();

    // Set to default if the user didn't choose a directory
    if (autoExportDirectoryPreference.isEmpty) {
      return setAutoExportDirectoryToDefault();
    }

    final persistedPermissions = await saf.persistedUriPermissions();

    // Set to default if no URI permissions are persisted by SAF
    if (persistedPermissions == null || persistedPermissions.isEmpty) {
      return setAutoExportDirectoryToDefault();
    }

    final persistedUris = persistedPermissions.map((permission) => permission.uri);
    final persistedAutoExportDirectory = persistedUris.firstWhereOrNull((uri) {
      return uri.path == autoExportDirectoryPreference;
    });

    // Set to default if no URI permission corresponding to the user preference is persisted by SAF,
    // or if the directory doesn't exist or doesn't have write permission
    if (persistedAutoExportDirectory == null ||
        !(await saf.exists(persistedAutoExportDirectory) ?? false) ||
        !(await saf.canWrite(persistedAutoExportDirectory) ?? false)) {
      return setAutoExportDirectoryToDefault();
    }

    autoExportDirectory = persistedAutoExportDirectory;
  }

  /// Sets the auto export directory to its default value (the application documents).
  Future<void> setAutoExportDirectoryToDefault() async {
    autoExportDirectory = (await getApplicationDocumentsDirectory()).uri;
  }

  /// Checks if an auto export should be performed.
  ///
  /// An auto export should be performed if it is enabled and either if no auto export has been performed yet,
  /// or the time difference between now and the last auto export is greater than the auto export frequency
  /// chosen by the user
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
