import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/note/note.dart';
import '../../../providers/notes/notes_provider.dart';
import '../../../providers/notifiers/notifiers.dart';

/// Saves the edited [note] in the notes provider that shows it (archived notes are not filtered by label).
Future<bool> editNote(WidgetRef ref, Note note) {
  final label = note.archived ? null : currentLabelFilter;

  return ref.read(notesProvider(status: note.status, label: label).notifier).edit(note);
}
