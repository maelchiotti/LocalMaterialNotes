import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages user preferences.
class PreferencesUtils {
  static final PreferencesUtils _singleton = PreferencesUtils._internal();

  factory PreferencesUtils() {
    return _singleton;
  }

  PreferencesUtils._internal();

  /// Normal preferences.
  late final SharedPreferences _preferences;

  /// Securely stored preferences.
  late final FlutterSecureStorage _secureStorage;

  /// Ensures the utility is initialized.
  Future<void> ensureInitialized() async {
    _preferences = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  /// Sets the [key] of the preference to the [value].
  ///
  /// The type [T] of the value should be a basic type: `bool`, `int`, `double`, `String` or `List<String>`.
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

  /// Returns the value of the [preferenceKey].
  ///
  /// The type [T] of the value should be a basic type: `bool`, `int`, `double`, `String` or `List<String>`.
  T? get<T>(PreferenceKey preferenceKey) {
    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    return _preferences.get(preferenceKey.name) as T?;
  }

  /// Removes the value of the [preferenceKey].
  Future<void> remove(PreferenceKey preferenceKey) async {
    await _preferences.remove(preferenceKey.name);
  }

  /// Clears all the preferences.
  Future<void> clear() async {
    await _preferences.clear();
  }

  /// Securely sets the [preferenceKey] to the [value].
  void setSecure(PreferenceKey preferenceKey, String value) {
    _secureStorage.write(key: preferenceKey.name, value: value);
  }

  /// Returns the value of the securely stored [preferenceKey].
  Future<String?> getSecure(PreferenceKey preferenceKey) async {
    return await _secureStorage.read(key: preferenceKey.name);
  }

  /// Deletes the value of the securely stored [preferenceKey].
  Future<void> deleteSecure(PreferenceKey preferenceKey) async {
    await _secureStorage.delete(key: preferenceKey.name);
  }
}
