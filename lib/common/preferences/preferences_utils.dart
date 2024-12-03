import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:localmaterialnotes/common/preferences/preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages user preferences.
class PreferencesUtils {
  static final PreferencesUtils _singleton = PreferencesUtils._internal();

  /// Default constructor.
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
  Future<void> set<T>(PreferenceKey preferenceKey, T value) async {
    if (preferenceKey.secure) {
      _secureStorage.write(key: preferenceKey.name, value: value as String);

      return;
    }

    if (T == bool) {
      await _preferences.setBool(preferenceKey.name, value as bool);
    } else if (T == int) {
      await _preferences.setInt(preferenceKey.name, value as int);
    } else if (T == double) {
      await _preferences.setDouble(preferenceKey.name, value as double);
    } else if (T == String) {
      await _preferences.setString(preferenceKey.name, value as String);
    } else if (T == List<String>) {
      await _preferences.setStringList(preferenceKey.name, value as List<String>);
    }
  }

  /// Returns the value of the [preferenceKey].
  ///
  /// The type [T] of the value should be a basic type: `bool`, `int`, `double`, `String` or `List<String>`.
  T? get<T>(PreferenceKey preferenceKey) {
    if (preferenceKey.secure) {
      throw ArgumentError('The preference is securely stored, use getSecure() instead');
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
  Future<void> remove(PreferenceKey preferenceKey) async {
    if (preferenceKey.secure) {
      await _secureStorage.delete(key: preferenceKey.name);

      return;
    }

    await _preferences.remove(preferenceKey.name);
  }

  /// Clears all the preferences and all the securely stored preferences.
  Future<void> clear() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
  }

  /// Returns the preferences names and their values as a JSON map.
  ///
  /// The value is null is the preference is not set.
  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> preferences = {};

    for (PreferenceKey preferenceKey in PreferenceKey.values) {
      final value = preferenceKey.secure
          ? await preferenceKey.getPreferenceOrDefaultSecure()
          : preferenceKey.getPreference<dynamic>();

      preferences[preferenceKey.name] = value;
    }

    return preferences;
  }
}
