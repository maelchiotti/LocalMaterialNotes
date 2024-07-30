import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:localmaterialnotes/utils/constants/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoUtils {
  static final InfoUtils _singleton = InfoUtils._internal();

  factory InfoUtils() {
    return _singleton;
  }

  InfoUtils._internal();

  late final PackageInfo _packageInfo;
  late final AndroidDeviceInfo _androidDeviceInfo;

  Future<void> ensureInitialized() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
  }

  String get appVersion => _packageInfo.version;

  int get androidVersion => _androidDeviceInfo.version.sdkInt;

  String get buildMode =>
      kReleaseMode ? localizations.settings_build_mode_release : localizations.settings_build_mode_debug;
}
