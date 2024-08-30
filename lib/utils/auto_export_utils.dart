import 'package:collection/collection.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:localmaterialnotes/common/preferences/preferences_utils.dart';
import 'package:localmaterialnotes/utils/database_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_storage/shared_storage.dart' as saf;

/// Utilities for the automatic export functionality.
///
/// This class is a singleton.
class AutoExportUtils {
  static final AutoExportUtils _singleton = AutoExportUtils._internal();

  factory AutoExportUtils() {
    return _singleton;
  }

  AutoExportUtils._internal();

  /// Directory where automatic exports are saved.
  late Uri autoExportDirectory;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    await setAutoExportDirectory();
    await performAutoExportIfNeeded();
  }

  /// Sets the directory where automatic exports are located depending on the user preference and the available
  /// permissions.
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

  /// Sets the automatic export directory to its default value (the application documents).
  Future<void> setAutoExportDirectoryToDefault() async {
    autoExportDirectory = (await getApplicationDocumentsDirectory()).uri;
  }

  /// Checks if an automatic export should be performed.
  ///
  /// An automatic export should be performed if it is enabled and either if no automatic export has been performed yet,
  /// or the time difference between now and the last automatic export is greater than the automatic export frequency
  /// chosen by the user
  bool _shouldPerformAutoExport() {
    final enableAutoExport = PreferenceKey.enableAutoExport.getPreferenceOrDefault<bool>();
    final autoExportFrequency = PreferenceKey.autoExportFrequency.getPreferenceOrDefault<int>();

    if (!enableAutoExport) {
      return false;
    }

    final lastAutoExportDatePreference = PreferenceKey.lastAutoExportDate.getPreferenceOrDefault<String>();
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

    final encrypt = PreferenceKey.autoExportEncryption.getPreferenceOrDefault<bool>();
    final password = await PreferenceKey.autoExportPassword.getPreferenceOrDefaultSecure();

    DatabaseUtils().autoExportAsJson(encrypt, password);

    PreferencesUtils().set<String>(
      PreferenceKey.lastAutoExportDate,
      DateTime.now().toIso8601String(),
    );
  }
}
