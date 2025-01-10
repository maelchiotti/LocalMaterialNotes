import 'package:flutter_helper_utils/flutter_helper_utils.dart';
import 'package:settings_tiles/settings_tiles.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import 'note.dart';

/// Types of the notes.
class NotesTypes {
  /// Returns the list of all the notes types.
  static List<MultipleOptionsDetails> all() {
    return [
      (
        value: PlainTextNote,
        title: l.note_type_plain_text,
        subtitle: null,
      ),
      (
        value: RichTextNote,
        title: l.note_type_rich_text,
        subtitle: null,
      ),
    ];
  }

  /// Returns the list of notes types saved in the preferences as a list of [Type].
  static List<Type> fromPreference() {
    final availableNotesTypes = <Type>[];
    final availableNotesTypesPreference = PreferenceKey.availableNotesTypes.getPreferenceOrDefault();

    for (final type in availableNotesTypesPreference) {
      switch (type) {
        case 'PlainTextNote':
          availableNotesTypes.add(PlainTextNote);
        case 'RichTextNote':
          availableNotesTypes.add(RichTextNote);
        default:
          throw Exception('Unknown note type: $type');
      }
    }

    assert(availableNotesTypes.isNotEmpty, 'The list of available notes types is empty');

    return availableNotesTypes;
  }

  /// Returns the list of notes types saved in the preferences as a comma-separated [String].
  static String fromPreferenceAsString() {
    final availableNotesTypesAsString = <String>[];
    final availableNotesTypesPreference = PreferenceKey.availableNotesTypes.getPreferenceOrDefault();

    for (final type in availableNotesTypesPreference) {
      switch (type) {
        case 'PlainTextNote':
          availableNotesTypesAsString.add(l.note_type_plain_text);
        case 'RichTextNote':
          availableNotesTypesAsString.add(l.note_type_rich_text);
        default:
          throw Exception('Unknown note type: $type');
      }
    }

    assert(availableNotesTypesAsString.isNotEmpty, 'The list of available notes types as string is empty');

    return availableNotesTypesAsString.join(', ').capitalizeFirstLowerRest;
  }

  /// Returns the list of [notesTypes] as a list of [String] to be saved in the preferences.
  static List<String> toPreference(List<Type> notesTypes) {
    return notesTypes.map((type) => type.toString()).toList();
  }
}
