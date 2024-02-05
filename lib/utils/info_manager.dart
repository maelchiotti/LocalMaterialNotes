import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class InfoManager {
  static final InfoManager _singleton = InfoManager._internal();

  factory InfoManager() {
    return _singleton;
  }

  InfoManager._internal();

  late final PackageInfo _packageInfo;
  late final AndroidDeviceInfo _androidDeviceInfo;

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
  }

  String get appVersion => _packageInfo.version;

  int get androidVersion => _androidDeviceInfo.version.sdkInt;
}
