// ignore_for_file: public_member_api_docs

/// Lists sizes.
enum Sizes {
  /// Allows to access custom sizes.
  custom(0),
  size2(2),
  size4(4),
  size8(8),
  size16(16),
  size32(32),
  size64(64),
  size128(128),
  size256(256),
  size512(512),
  size1024(1024),
  size2048(2048),
  ;

  /// Size to apply.
  final double size;

  const Sizes(this.size);

  /// Infinity.
  double get infinity => double.infinity;

  /// Width of a column in grid layout.
  int get gridLayoutColumnWidth => 384;

  /// Height of a button in the editor toolbar.
  double get editorToolbarButtonHeight => 42;

  /// Width of a button in the editor toolbar.
  double get editorToolbarButtonWidth => 42;

  /// Spacing between the notes tiles in the grid layout.
  double get notesGridLayoutSpacing => 8;
}
