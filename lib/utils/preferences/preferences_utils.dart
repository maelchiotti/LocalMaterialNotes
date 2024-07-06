import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static final PreferencesUtils _singleton = PreferencesUtils._internal();

  factory PreferencesUtils() {
    return _singleton;
  }

  PreferencesUtils._internal();

  late final SharedPreferences _preferences;
  late final FlutterSecureStorage _secureStorage;

  Future<void> ensureInitialized() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
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

  void setSecure(String key, String value) {
    _secureStorage.write(key: key, value: value);
  }

  Future<String?> getSecure(PreferenceKey preferenceKey) async {
    return await _secureStorage.read(key: preferenceKey.name);
  }
}
