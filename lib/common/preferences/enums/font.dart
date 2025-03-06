// ignore_for_file: public_member_api_docs

import '../../constants/constants.dart';
import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// List of fonts.
enum Font {
  systemDefault('Roboto'),
  barlow('Barlow', 'Barlow'),
  comicSansMS('Comic Sans MS', 'Comic Sans MS'),
  dancingScript('Dancing Script', 'Dancing Script'),
  jetBrainsMono('JetBrains Mono', 'JetBrains Mono'),
  merriweather('Merriweather', 'Merriweather'),
  montserrat('Montserrat', 'Montserrat'),
  notoSans('Noto Sans', 'Noto Sans'),
  openSans('Open Sans', 'Open Sans'),
  playfairDisplay('Playfair Display', 'Playfair Display'),
  raleway('Raleway', 'Raleway'),
  robotoMono('Roboto Mono', 'Roboto Mono'),
  ubuntu('Ubuntu', 'Ubuntu');

  /// The name of the font family.
  final String familyName;

  /// The name of the font family to display.
  final String? _displayName;

  /// A font identified by its [familyName] that can be used in the application.
  const Font(this.familyName, [this._displayName]);

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Font.appFromPreference() {
    final font = Font.values.byNameOrNull(PreferenceKey.appFont.preference);

    // Reset the malformed preference to its default value
    if (font == null) {
      PreferenceKey.appFont.reset();

      return Font.values.byName(PreferenceKey.appFont.defaultValue);
    }

    return font;
  }

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Font.editorFromPreference() {
    final font = Font.values.byNameOrNull(PreferenceKey.editorFont.preference);

    // Reset the malformed preference to its default value
    if (font == null) {
      PreferenceKey.editorFont.reset();

      return Font.values.byName(PreferenceKey.editorFont.defaultValue);
    }

    return font;
  }

  /// Returns the display name of this font.
  String get displayName {
    // Return the localized display name for the system default font
    if (this == systemDefault) {
      return l.font_system_default;
    }

    return _displayName!;
  }
}
