import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoManager {
  static final PackageInfoManager _singleton = PackageInfoManager._internal();

  factory PackageInfoManager() {
    return _singleton;
  }

  PackageInfoManager._internal();

  late final PackageInfo _packageInfo;

  Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  String get version => _packageInfo.version;
}
