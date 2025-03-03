// ignore_for_file: public_member_api_docs

/// Lists sizes.
enum Sizes {
  /// Infinity
  infinity(double.infinity),

  /// The size of the icon.
  appIcon(64),

  /// The large size of the icon.
  appIconLarge(128),

  /// The size of the icon in a settings page when displaying the value of a setting.
  settingValueIconSize(16),

  /// The size of small icons.
  iconSmall(16),

  /// The size of extra small icons.
  iconExtraSmall(12),

  /// The size of the empty placeholder icon.
  placeholderIcon(64),

  /// The width of a column in grid layout.
  gridLayoutColumnWidth(384),

  /// The height of the editor's toolbar
  editorToolbarHeight(54),

  /// Height of the labels list in the editor.
  editorLabelsListHeight(38),

  /// The height of a button in the editor toolbar.
  editorToolbarButtonHeight(42),

  /// The width of a button in the editor toolbar.
  editorToolbarButtonWidth(42),

  /// Spacing between the notes tiles in the grid layout.
  notesGridLayoutSpacing(8),

  /// Size of the color indicators.
  colorIndicator(40),

  /// Padding at the end of the app bars.
  appBarEnd(8),
  ;

  /// The size to apply.
  final double size;

  /// The [size].
  const Sizes(this.size);
}
