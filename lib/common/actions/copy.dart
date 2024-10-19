import 'package:flutter/services.dart';
import 'package:localmaterialnotes/common/constants/constants.dart';
import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/snack_bar_utils.dart';

/// Copies the content of the [note] to the clipboard.
Future<void> copy(Note note) async {
  Clipboard.setData(
    ClipboardData(text: note.contentPreview),
  );

  SnackBarUtils.info(l.snack_bar_copied).show();
}
