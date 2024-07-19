import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localmaterialnotes/common/routing/router_route.dart';
import 'package:localmaterialnotes/providers/bin/bin_provider.dart';
import 'package:localmaterialnotes/providers/notes/notes_provider.dart';
import 'package:localmaterialnotes/providers/notifiers.dart';

void selectAll(WidgetRef ref) {
  RouterRoute.isBin ? ref.read(binProvider.notifier).selectAll() : ref.read(notesProvider.notifier).selectAll();
}

void unselectAll(WidgetRef ref) {
  RouterRoute.isBin ? ref.read(binProvider.notifier).unselectAll() : ref.read(notesProvider.notifier).unselectAll();
}

void exitSelectionMode(WidgetRef ref) {
  unselectAll(ref);

  isSelectionModeNotifier.value = false;
}
