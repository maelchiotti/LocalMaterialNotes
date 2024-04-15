import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static final PreferencesManager _singleton = PreferencesManager._internal();

  factory PreferencesManager() {
    return _singleton;
  }

  PreferencesManager._internal();

  late final SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void set<T>(String key, T value) {
    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    if (T == bool) {
      _preferences.setBool(key, value as bool);
    } else if (T == int) {
      _preferences.setInt(key, value as int);
    } else if (T == double) {
      _preferences.setDouble(key, value as double);
    } else if (T == String) {
      _preferences.setString(key, value as String);
    } else if (T == List<String>) {
      _preferences.setStringList(key, value as List<String>);
    }
  }

  T? get<T>(PreferenceKey preferenceKey) {
    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    return _preferences.get(preferenceKey.name) as T?;
  }
}
