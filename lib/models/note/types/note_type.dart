import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../common/constants/constants.dart';
import '../../../common/extensions/string_extension.dart';
import '../../../common/preferences/preference_key.dart';

/// The types of notes.
enum NoteType {
  /// Plain text note.
  plainText(Icons.text_fields),

  /// Markdown.
  markdown(Symbols.markdown),

  /// Rich text note.
  richText(Icons.format_paint),

  /// Checklist note.
  checklist(Icons.checklist);

  /// Icon representing this note type.
  final IconData icon;

  const NoteType(this.icon);

  /// The title of this type.
  String get title {
    return switch (this) {
      plainText => l.note_type_plain_text,
      markdown => l.note_type_markdown,
      richText => l.note_type_rich_text,
      checklist => l.note_type_checklist,
    };
  }

  /// The types that can be used when creating a new note from a shortcut.
  static List<NoteType> get share => [plainText, markdown, richText];

  /// The list of types available when creating a new note from the notes list.
  static List<NoteType> get available {
    final availableTypesPreference = PreferenceKey.availableNotesTypes.preferenceOrDefault;

    return availableTypesPreference.map((type) {
      return values.byName(type);
    }).toList();
  }

  /// The list of types available when creating a new note from the notes list as a comma-separated [String].
  static String get availableAsString {
    return available.map((type) => type.title).join(', ').capitalizeFirstLowerRest;
  }

  /// The default note type to used when creating a new note via a share action.
  static NoteType get defaultShare {
    final defaultShortcutType = PreferenceKey.defaultShareNoteType.preferenceOrDefault;

    return values.byName(defaultShortcutType);
  }

  /// Returns the [types] as a list of [String] that can be saved to the preferences.
  static List<String> toPreference(List<NoteType> types) {
    return types.map((type) => type.name).toList();
  }
}
