import 'package:flutter/material.dart';

import '../../common/extensions/build_context_extension.dart';

/// The status of a note.
enum NoteStatus {
  /// The note is available.
  available,

  /// This note is archived.
  archived,

  /// The note is deleted.
  deleted;

  /// Returns the title of this status.
  String title(BuildContext context) {
    return switch (this) {
      available => context.l.navigation_notes,
      archived => context.l.navigation_archives,
      deleted => context.l.navigation_bin,
    };
  }
}
