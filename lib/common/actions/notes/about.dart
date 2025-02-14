import 'package:flutter/material.dart';

import '../../../pages/editor/sheets/about_sheet.dart';

/// Show the about drawer for the current note.
Future<void> showNoteAbout(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    clipBehavior: Clip.hardEdge,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const AboutSheet(),
  );
}
