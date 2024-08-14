/// Extends the [Uri] class with some utilities functions.
extension UriExtension on Uri {
  /// Returns the path of the URI with the spaces correctly encoded.
  ///
  /// By default, spaces are encoded with `%20` instead of a space.
  String get toDecodedString {
    return path.replaceAll('%20', ' ');
  }
}
