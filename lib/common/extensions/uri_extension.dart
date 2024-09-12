import 'package:path/path.dart';

/// Extends the [Uri] class with some utilities functions.
extension UriExtension on Uri {
  /// Returns the path of the URI with the separators correctly encoded.
  ///
  /// Useful for SAF URIs as it doesn't properly encode `:`.
  String get display {
    return joinAll(pathSegments);
  }
}
