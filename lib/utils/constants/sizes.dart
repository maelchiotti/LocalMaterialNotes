enum Sizes {
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

  final double size;

  double get zero => 0;

  double get infinity => double.infinity;

  double get searchAppBar => 8;

  double get searchBar => 48;

  int get gridLayoutColumnWidth => 384;

  double get editorToolbarHeight => 48;

  const Sizes(this.size);
}
