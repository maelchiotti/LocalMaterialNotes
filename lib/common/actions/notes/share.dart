import 'package:share_plus/share_plus.dart';

import '../../../models/note/note.dart';
import '../../constants/constants.dart';

/// Shares the [note] as text (title and content).
Future<void> shareNote(Note note) async {
  await Share.share(note.shareText, subject: note.title);
}

/// Shares the [notes] as text (title and content), separated by dashes.
Future<void> shareNotes(List<Note> notes) async {
  final text = notes.map((note) => note.shareText).join('\n\n----------\n\n');

  await Share.share(text, subject: l.action_share_subject(notes.length));
}
