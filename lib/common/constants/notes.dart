import 'package:localmaterialnotes/models/note/note.dart';
import 'package:localmaterialnotes/utils/localizations_utils.dart';

/// Note displayed on the very first run of the application to welcome the user.
final welcomeNote = Note(
  deleted: false,
  pinned: true,
  createdTime: DateTime.now(),
  editedTime: DateTime.now(),
  title: LocalizationsUtils().welcomeNoteTitle,
  content: '[{"insert":"${LocalizationsUtils().welcomeNoteContent}\\n"}]',
);

/// Notes used when running integration tests.
final integrationTestNotes = List.generate(
  100,
  (index) => Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 12).subtract(Duration(minutes: index)),
    editedTime: DateTime(2000, 01, 01, 12).subtract(Duration(minutes: index)),
    title: "Note $index",
    content: '[{"insert":"This is note $index.\\n"}]',
  ),
)..addAll(
    List.generate(
      100,
      (index) => Note(
        deleted: true,
        pinned: false,
        createdTime: DateTime(2000, 01, 01, 12).subtract(Duration(minutes: index)),
        editedTime: DateTime(2000, 01, 01, 12).subtract(Duration(minutes: index)),
        title: "Deleted note $index",
        content: '[{"insert":"This is deleted note $index.\\n"}]',
      ),
    ),
  );

/// Notes used when taking screenshots of the application for the stores.
final screenshotNotes = [
  Note(
    deleted: false,
    pinned: true,
    createdTime: DateTime(2000, 01, 01, 12),
    editedTime: DateTime(2000, 01, 01, 12),
    title: "Welcome to Material Notes",
    content:
        '[{"insert":"Simple","attributes":{"b":true}},{"insert":", "},{"insert":"local","attributes":{"i":true}},{"insert":", "},{"insert":"material design","attributes":{"u":true}},{"insert":" notes\\n"}]',
  ),
  Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 55),
    editedTime: DateTime(2000, 01, 01, 11, 55),
    title: "Take notes",
    content:
        '[{"insert":"Write text notes"},{"insert":"\\n","attributes":{"block":"cl","checked":true}},{"insert":"Use formatting options and undo/redo"},{"insert":"\\n","attributes":{"block":"cl","checked":true}},{"insert":"Use quick action to add from your homescreen"},{"insert":"\\n","attributes":{"block":"cl","checked":true}}]',
  ),
  Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 50),
    editedTime: DateTime(2000, 01, 01, 11, 50),
    title: "Organize",
    content: '[{"insert":"Search, sort and display in a list or a grid\\nPin and recover from the bin\\n"}]',
  ),
  Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 50),
    editedTime: DateTime(2000, 01, 01, 11, 50),
    title: "Categorize",
    content: '[{"insert":"Categorize notes with labels\\nPin, hide and colorize labels\\n"}]',
  ),
  Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 45),
    editedTime: DateTime(2000, 01, 01, 11, 45),
    title: "Share & backup",
    content:
        '[{"insert":"Create a note from shared text\\nShare notes as text and export as Markdown\\nBackup notes as JSON\\n"}]',
  ),
  Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 40),
    editedTime: DateTime(2000, 01, 01, 11, 40),
    title: "Customize",
    content:
        "[{\"insert\":\"Choose your language\\nChoose your theme (including black and dynamic)\\nHide features you don't need\\n\"}]",
  ),
  Note(
    deleted: false,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 11, 35),
    editedTime: DateTime(2000, 01, 01, 11, 35),
    title: "Protect",
    content: '[{"insert":"Your data never leaves your device\\nEncrypt your exports\\n"}]',
  ),
  Note(
    deleted: true,
    pinned: false,
    createdTime: DateTime(2000, 01, 01, 12),
    editedTime: DateTime(2000, 01, 01, 12),
    title: "Recover notes from the bin!",
    content: '[{"insert":"Or delete them for good\\n"}]',
  ),
];
