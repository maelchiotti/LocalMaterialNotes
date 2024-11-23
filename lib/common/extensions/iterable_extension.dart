/// Extends the [Iterable] class with some utilities functions.
extension IterableExtension<T extends Enum> on Iterable<T> {
  /// Returns the enum value for the [name] or `null` if it doesn't exist.
  T? byNameOrNull(String? name) {
    if (name == null) {
      return null;
    }

    for (var value in this) {
      if (value.name == name) {
        return value;
      }
    }

    return null;
  }
}
