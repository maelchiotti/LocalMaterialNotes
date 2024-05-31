enum Asset {
  icon('icons/icon.png'),
  ;

  final _basePath = 'assets';

  final String _filePath;

  const Asset(this._filePath);

  String get path => '$_basePath/$_filePath';
}
