import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/extensions/build_context_extension.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';
import 'package:localmaterialnotes/routing/routes/routing_route.dart';

/// Selects all the notes.
///
/// Depending on the current route, selects either the notes from the notes page or those from the bin page.
void selectAll(BuildContext context, WidgetRef ref) {
  final isNotesRoute = context.route == RoutingRoute.notes;

  isNotesRoute ? ref.read(notesProvider.notifier).selectAll() : ref.read(binProvider.notifier).selectAll();
}

/// Unselects all the notes.
///
/// Depending on the current route, unselects either the notes from the notes page or those from the bin page.
void unselectAll(BuildContext context, WidgetRef ref) {
  final isBin = context.route == RoutingRoute.notes;

  isBin ? ref.read(notesProvider.notifier).unselectAll() : ref.read(binProvider.notifier).unselectAll();
}

/// Exits the selection mode.
///
/// First unselects all the notes.
void exitSelectionMode(BuildContext context, WidgetRef ref) {
  unselectAll(context, ref);

  isSelectionModeNotifier.value = false;
}
