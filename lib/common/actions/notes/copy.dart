import 'package:flutter/services.dart';
import '../../constants/constants.dart';
import '../../../models/note/note.dart';
import '../../../utils/snack_bar_utils.dart';

/// Copies the content of the [note] to the clipboard.
Future<void> copyNote(Note note) async {
  Clipboard.setData(
    ClipboardData(text: note.contentPreview),
  );

  SnackBarUtils.info(l.snack_bar_copied).show();
}
