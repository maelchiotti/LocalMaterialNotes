extension UriExtension on Uri {
  String get toDecodedString {
    return path.replaceAll('%20', ' ');
  }
}
