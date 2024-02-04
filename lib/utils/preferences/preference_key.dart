enum PreferenceKey {
  locale,
  theme,
  dynamicTheming(true),
  blackTheming(false),
  sortMethod('date'),
  sortAscending(false),
  confirmations('irreversible'),
  ;

  final Object? defaultValue;

  const PreferenceKey([this.defaultValue]);
}
