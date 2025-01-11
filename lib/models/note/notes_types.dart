import 'package:flutter_helper_utils/flutter_helper_utils.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import 'note.dart';

/// The types of notes.
enum NoteType<T extends Note> {
  /// Plain text note.
  plainText<PlainTextNote>(),

  /// Rich text note.
  richText<RichTextNote>(),
  ;

  const NoteType();

  /// The title of this type.
  String get title {
    return switch (T) {
      == PlainTextNote => l.note_type_plain_text,
      == RichTextNote => l.note_type_rich_text,
      _ => throw Exception('Unknown note type: $T'),
    };
  }

  /// The types that can be used when creating a new note from a shortcut.
  static List<NoteType> get shortcutTypes => [plainText, richText];

  /// The list of types available when creating a new note from the notes list.
  static List<NoteType> get availableTypes {
    final availableTypesPreference = PreferenceKey.availableNotesTypes.getPreferenceOrDefault();

    return availableTypesPreference.map((type) {
      return values.byName(type);
    }).toList();
  }

  /// The list of types available when creating a new note from the notes list as a comma-separated [String].
  static String get availableTypesAsString {
    return availableTypes.map((type) => type.title).join(', ').capitalizeFirstLowerRest;
  }

  /// The default note type to used when creating a new note from a shortcut.
  static NoteType get defaultShortcutType {
    final defaultShortcutType = PreferenceKey.defaultShortcutNoteType.getPreferenceOrDefault();

    return values.byName(defaultShortcutType);
  }

  /// Returns the [types] as a list of [String] that can be saved to the preferences.
  static List<String> toPreference(List<NoteType> types) {
    return types.map((type) => type.name).toList();
  }
}
