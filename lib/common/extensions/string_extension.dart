/// Extends the [String] class with some utilities functions.
extension StringExtension on String {
  /// Returns this string with the first letter capitalized and the rest to lower case.
  String get capitalizeFirstLowerRest {
    if (trim().length < 2) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Returns whether the password is a strong one.
  ///
  /// A strong password must contain at least:
  ///   - 1 lowercase
  ///   - 1 uppercase
  ///   - 1 number
  ///   - 1 special character
  bool get isStrongPassword {
    final regex = RegExp(
      r'''^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"'[{\]}\|^]).{12,}$''',
    );

    return regex.hasMatch(this);
  }

  /// Returns the storage volume and the path inside it of this Storage Access Framework URI of a document or a tree.
  ///
  /// For example, `content://com.android.externalstorage.documents/tree/primary%3ADocuments%2Fbackups` gives the
  /// volume `primary` and the path `Documents/backups`. The volume is `null` when the URI only gives a path, like the
  /// `raw:` documents of the downloads provider.
  ///
  /// Returns `null` if this string is not such an URI or if it doesn't contain a readable path.
  ({String? volume, String path})? get safPath {
    final uri = Uri.tryParse(this);
    if (uri == null || uri.scheme != 'content') {
      return null;
    }

    // The document ID is after `document` if the URI has one, otherwise after `tree`
    final segments = uri.pathSegments;
    final documentIndex = segments.lastIndexOf('document');
    final treeIndex = segments.indexOf('tree');
    final idIndex = documentIndex != -1 ? documentIndex + 1 : (treeIndex != -1 ? treeIndex + 1 : -1);
    if (idIndex == -1 || idIndex >= segments.length) {
      return null;
    }
    final documentId = segments[idIndex];

    // The downloads provider can give the absolute path of the document
    if (documentId.startsWith('raw:')) {
      return (volume: null, path: documentId.substring('raw:'.length));
    }

    // Only the external storage provider uses the `volume:path` format for its document IDs
    final separatorIndex = documentId.indexOf(':');
    if (uri.host != 'com.android.externalstorage.documents' || separatorIndex == -1) {
      return null;
    }

    final volume = documentId.substring(0, separatorIndex);
    final path = documentId.substring(separatorIndex + 1);

    // The `home` volume is the documents directory of the internal storage
    if (volume == 'home') {
      return (volume: 'primary', path: path.isEmpty ? 'Documents' : 'Documents/$path');
    }

    return (volume: volume, path: path);
  }

  /// Returns the first line of the string.
  String? get firstLine => split('\n').firstOrNull;
}
