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

  /// Returns the encoded URI as decoded.
  ///
  /// Decodes `:`, `/` and `␣`.
  String get decoded {
    var uri = this;

    uri = uri.replaceAll('%3A', ':');
    uri = uri.replaceAll('%2F', '/');
    uri = uri.replaceAll('%20', ' ');

    return uri;
  }

  /// Returns the first line of the string.
  String? get firstLine => split('\n').firstOrNull;
}
