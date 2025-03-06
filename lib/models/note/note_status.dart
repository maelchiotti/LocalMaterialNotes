import '../../common/constants/constants.dart';

/// The status of a note.
enum NoteStatus {
  /// The note is available.
  available,

  /// This note is archived.
  archived,

  /// The note is deleted.
  deleted;

  /// Returns the title of this status.
  String get title {
    return switch (this) {
      available => l.navigation_notes,
      archived => l.navigation_archives,
      deleted => l.navigation_bin,
    };
  }
}
