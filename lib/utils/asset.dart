import 'package:path/path.dart';

/// Lists the application's assets.
enum Asset {
  /// Application's icon.
  icon('icons/icon.png'),
  ;

  /// Base path of the assets.
  final _basePath = 'assets';

  /// Path of the asset inside the [_basePath].
  final String _filePath;

  const Asset(this._filePath);

  /// Full path of the asset (combination of the [_basePath] and the [_filePath].
  String get path => join(_basePath, _filePath);
}
