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

  /// Sets the [preferenceKey] to the [value].
  ///
  /// The type [T] of the value should be a basic type: `bool`, `int`, `double`, `String` or `List<String>`.
  void set<T>(PreferenceKey preferenceKey, T value) {
    if (preferenceKey.secure) {
      _secureStorage.write(key: preferenceKey.name, value: value as String);

      return;
    }

    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    if (T == bool) {
      _preferences.setBool(preferenceKey.name, value as bool);
    } else if (T == int) {
      _preferences.setInt(preferenceKey.name, value as int);
    } else if (T == double) {
      _preferences.setDouble(preferenceKey.name, value as double);
    } else if (T == String) {
      _preferences.setString(preferenceKey.name, value as String);
    } else if (T == List<String>) {
      _preferences.setStringList(preferenceKey.name, value as List<String>);
    }
  }

  /// Returns the value of the [preferenceKey].
  ///
  /// The type [T] of the value should be a basic type: `bool`, `int`, `double`, `String` or `List<String>`.
  T? get<T>(PreferenceKey preferenceKey) {
    if (preferenceKey.secure) {
      throw ArgumentError('The preference is securely stored, use getSecure() instead');
    }

    if (T == dynamic) {
      throw ArgumentError('The type T is required.');
    }

    return _preferences.get(preferenceKey.name) as T?;
  }

  /// Returns the value of the securely stored [preferenceKey].
  Future<String?> getSecure(PreferenceKey preferenceKey) async {
    if (!preferenceKey.secure) {
      throw ArgumentError('The preference is not securely stored, use get<T>() instead');
    }

    return await _secureStorage.read(key: preferenceKey.name);
  }

  /// Removes the value of the [preferenceKey].
  void remove(PreferenceKey preferenceKey) {
    if (preferenceKey.secure) {
      _secureStorage.delete(key: preferenceKey.name);

      return;
    }

    _preferences.remove(preferenceKey.name);
  }

  /// Clears all the preferences and all the securely stored preferences.
  void clear() {
    _preferences.clear();
    _secureStorage.deleteAll();
  }
}
