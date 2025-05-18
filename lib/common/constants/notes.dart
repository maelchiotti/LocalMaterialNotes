import '../../models/note/note.dart';
import '../system_utils.dart';

/// Note displayed on the very first run of the application to welcome the user.
final welcomeNote = PlainTextNote(
  archived: false,
  deleted: false,
  pinned: true,
  createdTime: DateTime.now(),
  editedTime: DateTime.now(),
  title: SystemUtils().welcomeNoteTitle,
  content: SystemUtils().welcomeNoteContent,
);

/// Notes used when taking screenshots of the application for the stores.
final screenshotNotes = [
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: true,
    createdTime: DateTime(2000, 01, 01, 12),
    editedTime: DateTime(2000, 01, 01, 12),
    title: "Welcome to Material Notes",
    content:
        '[{"insert":"Simple","attributes":{"b":true}},{"insert":", "},{"insert":"local","attributes":{"i":true}},{"insert":", "},{"insert":"material design","attributes":{"u":true}},{"insert":" notes\\n"}]',
  ),
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 55),
    editedTime: DateTime(2000, 01, 01, 11, 55),
    title: "Take notes",
    content:
        '[{"insert":"Write text notes"},{"insert":"\\n","attributes":{"block":"cl","checked":true}},{"insert":"Use plain text, markdown, rich text or checklist notes"},{"insert":"\\n","attributes":{"block":"cl","checked":true}},{"insert":"Use quick action to add from your home screen"},{"insert":"\\n","attributes":{"block":"cl","checked":true}}]',
  ),
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 50),
    editedTime: DateTime(2000, 01, 01, 11, 50),
    title: "Organize",
    content: '[{"insert":"Search, sort and display in a list or a grid\\nPin, archive and recover from the bin\\n"}]',
  ),
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 50),
    editedTime: DateTime(2000, 01, 01, 11, 50),
    title: "Categorize",
    content: '[{"insert":"Categorize notes with labels\\nPin, hide and colorize labels\\n"}]',
  ),
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 45),
    editedTime: DateTime(2000, 01, 01, 11, 45),
    title: "Share & backup",
    content:
        '[{"insert":"Create a note from shared text\\nShare notes as text and export as Markdown\\nBackup notes as JSON\\n"}]',
  ),
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 35),
    editedTime: DateTime(2000, 01, 01, 11, 35),
    title: "Protect",
    content:
        '[{"insert":"Your data never leaves your device\\nLock the app, a note or a label\\nEncrypt your exports\\n"}]',
  ),
  RichTextNote(
    archived: false,
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 40),
    editedTime: DateTime(2000, 01, 01, 11, 40),
    title: "Customize",
    content:
        "[{\"insert\":\"Choose your language\\nChoose your theme (including black and dynamic)\\nHide features you don't need\\n\"}]",
  ),
  RichTextNote(
    archived: false,
    deleted: true,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 12),
    editedTime: DateTime(2000, 01, 01, 12),
    title: "Recover notes from the bin!",
    content: '[{"insert":"Or delete them for good\\n"}]',
  ),
];
