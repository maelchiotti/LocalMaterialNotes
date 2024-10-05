import 'package:localmaterialnotes/models/note/note.dart';
import 'package:share_plus/share_plus.dart';

/// Shares the [note] as text (title and content).
Future<void> share(Note note) async {
  await Share.share(note.shareText, subject: note.title);
}
