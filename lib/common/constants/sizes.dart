// ignore_for_file: public_member_api_docs

/// Lists sizes.
enum Sizes {
  /// Infinity
  infinity(double.infinity),

  /// The size of the icon.
  iconSize(64),

  /// The size of the pin icon in a note tile.
  pinIconSize(8),

  /// The size of the empty placeholder icon.
  placeholderIcon(64),

  /// The width of a column in grid layout.
  gridLayoutColumnWidth(384),

  /// The height of the editor's toolbar
  editorToolbarHeight(54),

  /// The height of a button in the editor toolbar.
  editorToolbarButtonHeight(42),

  /// The width of a button in the editor toolbar.
  editorToolbarButtonWidth(42),

  /// Spacing between the notes tiles in the grid layout.
  notesGridLayoutSpacing(8),
  ;

  /// The size to apply.
  final double size;

  /// The [size].
  const Sizes(this.size);
}
