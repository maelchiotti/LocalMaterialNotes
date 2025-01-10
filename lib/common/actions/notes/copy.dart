import 'package:flutter/services.dart';

import '../../../models/note/note.dart';
import '../../../utils/snack_bar_utils.dart';
import '../../constants/constants.dart';

/// Copies the content of the [note] to the clipboard.
Future<void> copyNote({required Note note}) async {
  Clipboard.setData(
    ClipboardData(text: note.contentPreview),
  );

  SnackBarUtils.info(l.snack_bar_copied).show();
}
