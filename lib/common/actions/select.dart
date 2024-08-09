import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

/// Selects all the notes.
///
/// Depending on the current route, selects either the notes from the notes page or those from the bin page.
void selectAll(WidgetRef ref) {
  RouterRoute.isBin ? ref.read(binProvider.notifier).selectAll() : ref.read(notesProvider.notifier).selectAll();
}

/// Unselects all the notes.
///
/// Depending on the current route, unselects either the notes from the notes page or those from the bin page.
void unselectAll(WidgetRef ref) {
  RouterRoute.isBin ? ref.read(binProvider.notifier).unselectAll() : ref.read(notesProvider.notifier).unselectAll();
}

/// Exits the selection mode.
///
/// First unselects all the notes.
void exitSelectionMode(WidgetRef ref) {
  unselectAll(ref);

  isSelectionModeNotifier.value = false;
}
