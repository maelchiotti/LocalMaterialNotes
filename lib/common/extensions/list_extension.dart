extension ListExtension<T> on List<T> {
  void addOrUpdate(T item) {
    final index = indexOf(item);

    if (index != -1) {
      this[index] = item;
    } else {
      add(item);
    }
  }
}
