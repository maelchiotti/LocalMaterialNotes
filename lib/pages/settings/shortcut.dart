import 'package:localmaterialnotes/utils/constants/constants.dart';

enum Shortcut {
  bold('CTRL+B'),
  italic('CTRL+I'),
  underline('CTRL+U'),
  undo('CTRL+Z'),
  redo('CTRL+MAJ+Z'),
  ;

  final String keys;

  const Shortcut(this.keys);

  String get title {
    switch (this) {
      case Shortcut.bold:
        return localizations.shortcut_bold;
      case Shortcut.italic:
        return localizations.shortcut_italic;
      case Shortcut.underline:
        return localizations.shortcut_underline;
      case Shortcut.undo:
        return localizations.shortcut_undo;
      case Shortcut.redo:
        return localizations.shortcut_redo;
    }
  }
}
