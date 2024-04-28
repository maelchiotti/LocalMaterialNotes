enum SortMethod {
  date('date'),
  title('title'),
  ascending('ascending'),
  ;

  final String name;

  const SortMethod(this.name);
}
