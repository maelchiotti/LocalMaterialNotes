import 'package:flutter_helper_utils/flutter_helper_utils.dart';

import '../../common/constants/constants.dart';
import '../../common/preferences/preference_key.dart';
import 'note.dart';

enum NoteType<T extends Note> {
  plainText<PlainTextNote>(),
  richText<RichTextNote>(),
  ;

  const NoteType();

  String get title {
    return switch (T) {
      == PlainTextNote => l.note_type_plain_text,
      == RichTextNote => l.note_type_rich_text,
      _ => throw Exception('Unknown note type: $T'),
    };
  }

  /// Returns the list of notes types saved in the preferences as a list of [Type].
  static List<NoteType> get availableTypes {
    final availableTypesPreference = PreferenceKey.availableNotesTypes.getPreferenceOrDefault();

    return availableTypesPreference.map((type) {
      return values.byName(type);
    }).toList();
  }

  /// Returns the list of notes types saved in the preferences as a comma-separated [String].
  static String get availableTypesAsString {
    return availableTypes.map((type) => type.title).join(', ').capitalizeFirstLowerRest;
  }

  static List<String> toPreference(List<NoteType> types) {
    return types.map((type) => type.name).toList();
  }
}
