import 'package:flutter/material.dart';

import '../../../pages/editor/sheets/about_sheet.dart';
import '../../constants/constants.dart';

/// Show the about drawer for the current note.
Future<void> showAboutNote() async {
  await showModalBottomSheet<void>(
    context: rootNavigatorKey.currentContext!,
    clipBehavior: Clip.hardEdge,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const AboutSheet(),
  );
}
