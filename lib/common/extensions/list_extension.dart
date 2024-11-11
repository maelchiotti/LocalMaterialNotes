/// Extends the [List] class with some utilities functions.
extension ListExtension<T> on List<T> {
  /// Adds the [item] if it does not already exist in the list, or adds it otherwise.
  void addOrUpdate(T item) {
    final index = indexOf(item);

    if (index != -1) {
      this[index] = item;
    } else {
      add(item);
    }
  }
}
