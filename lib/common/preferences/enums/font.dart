// ignore_for_file: public_member_api_docs

import '../../extensions/iterable_extension.dart';
import '../preference_key.dart';

/// List of fonts.
enum Font {
  systemDefault('Roboto', 'System default'),
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
  ubuntu('Ubuntu', 'Ubuntu'),
  ;

  /// The name of the font family.
  final String? familyName;

  /// The name of the font family to display.
  final String displayName;

  /// A font identified by its [familyName] that can be used in the application.
  const Font(this.familyName, this.displayName);

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Font.appFromPreference() {
    final font = Font.values.byNameOrNull(
      PreferenceKey.appFont.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (font == null) {
      PreferenceKey.appFont.reset();

      return Font.values.byName(PreferenceKey.appFont.defaultValue);
    }

    return font;
  }

  /// Returns the value of the preference if set, or its default value otherwise.
  factory Font.editorFromPreference() {
    final font = Font.values.byNameOrNull(
      PreferenceKey.editorFont.getPreference(),
    );

    // Reset the malformed preference to its default value
    if (font == null) {
      PreferenceKey.editorFont.reset();

      return Font.values.byName(PreferenceKey.editorFont.defaultValue);
    }

    return font;
  }
}
