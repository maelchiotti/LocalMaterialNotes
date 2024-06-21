import 'package:flutter/services.dart';
import 'package:localmaterialnotes/utils/locale_utils.dart';
import 'package:yaml/yaml.dart';

class HardcodedLocalizationsUtils {
  static final HardcodedLocalizationsUtils _singleton = HardcodedLocalizationsUtils._internal();

  factory HardcodedLocalizationsUtils() {
    return _singleton;
  }

  HardcodedLocalizationsUtils._internal();

  late final YamlMap hardcodedLocalizations;

  Future<void> init() async {
    final yaml = await rootBundle.loadString("lib/l10n/hardcoded_localizations.yaml");
    hardcodedLocalizations = loadYaml(yaml) as YamlMap;
  }

  String _getHardcodedLocalization(String key) {
    final locale = LocaleUtils().appLocale;

    return (hardcodedLocalizations[key] as YamlMap)[locale.languageCode] as String;
  }

  String get actionAddNoteTitle => _getHardcodedLocalization('actionAddNoteTitle');

  String get welcomeNoteTitle => _getHardcodedLocalization('welcomeNoteTitle');

  String get welcomeNoteContent => _getHardcodedLocalization('welcomeNoteContent');
}
