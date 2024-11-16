/// Mime type.
enum MimeType {
  /// JSON text files.
  json('application/json', 'JSON files', 'json'),

  /// Markdown text files.
  markdown('text/markdown', 'Markdown files', 'md'),

  /// ZIP archive files.
  zip('application/zip', 'ZIP files', 'zip'),

  /// Log files.
  log('text/plain', 'Log files', 'log'),
  ;

  /// Value of the mime type.
  final String value;

  /// Name of the files associated to the [value].
  final String label;

  /// Extension of the files associated to the [value].
  final String extension;

  /// A mime type with its [value], a [label] and the corresponding file [extension].
  const MimeType(
    this.value,
    this.label,
    this.extension,
  );
}
