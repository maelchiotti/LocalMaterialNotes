import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Utilities for information about the application.
///
/// This class is a singleton.
class InfoUtils {
  static final InfoUtils _singleton = InfoUtils._internal();

  /// Default constructor.
  factory InfoUtils() {
    return _singleton;
  }

  InfoUtils._internal();

  /// Information about the package.
  late final PackageInfo _packageInfo;

  /// Information about the Android device.
  late final AndroidDeviceInfo _androidDeviceInfo;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
  }

  /// version of the application.
  String get appVersion => _packageInfo.version;

  /// Android version of the device.
  int get androidVersion => _androidDeviceInfo.version.sdkInt;

  /// Brand of the device
  String get brand => _androidDeviceInfo.brand;

  /// Model of the device.
  String get model => _androidDeviceInfo.model;

  /// Build mode of the application (either `release` or `debug`).
  String get buildMode => kReleaseMode ? l.settings_build_mode_release : l.settings_build_mode_debug;
}
