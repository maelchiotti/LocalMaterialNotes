import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart' show HMac, PBKDF2KeyDerivator, Pbkdf2Parameters, SHA256Digest;

/// The encryption of an export: the encrypter of its texts, and the parameters of its key derivation to store in it.
typedef ExportEncryption = ({Encrypter encrypter, Map<String, dynamic> parameters});

/// Utilities for AES encryption and decryption of strings based on a user provided password.
///
/// The texts are encrypted with AES-256 in CBC mode, with a random initialization vector per text.
///
/// Since version 2.4.0, the key is derived from the password with PBKDF2-HMAC-SHA256 and a random salt per export,
/// whose parameters are stored in the export (see [parametersKey]), so that the password can have any length.
/// Older exports have no parameters: their key is the password itself, which must be exactly 32 characters long.
class EncryptionUtils {
  /// The key of the parameters of the key derivation in the JSON exports.
  static const parametersKey = 'encryption';

  /// The name of the key derivation function in the parameters.
  static const keyDerivationFunction = 'pbkdf2-sha256';

  /// The number of iterations of the key derivation of the new exports.
  ///
  /// The derivation runs in Dart, so it's kept low enough to take a few seconds at most on a phone. Since it's stored
  /// in each export, it can be raised without breaking the older exports.
  static const keyDerivationIterations = 100000;

  /// The minimum length of a password.
  static const minimumPasswordLength = 12;

  /// The length of the salt of the key derivation, in bytes.
  static const _saltLength = 16;

  /// The length of the key, in bytes (AES-256).
  static const _keyLength = 32;

  /// Returns the encryption to use for a new export with the [password], with a new random salt.
  ///
  /// The key is derived in an isolate, so that the interface doesn't freeze.
  Future<ExportEncryption> forExport(String password) async {
    final salt = SecureRandom(_saltLength).bytes;
    const iterations = keyDerivationIterations;

    final key = await Isolate.run(() => _deriveKey(password, salt, iterations));

    return (
      encrypter: _encrypter(Key(key)),
      parameters: {'kdf': keyDerivationFunction, 'iterations': iterations, 'salt': base64.encode(salt)},
    );
  }

  /// Returns the encrypter to read an export encrypted with the [password] and the key derivation [parameters].
  ///
  /// If [parameters] is `null`, the export was made before version 2.4.0 and the [password] is the key itself.
  ///
  /// Throws a [FormatException] if the [parameters] are invalid, or if the [password] can't be the key of an older
  /// export.
  Future<Encrypter> forImport(String password, Object? parameters) async {
    if (parameters == null) {
      return legacyEncrypter(password);
    }

    if (parameters is! Map<String, dynamic>) {
      throw const FormatException('The encryption parameters of the export are not a map');
    }

    final kdf = parameters['kdf'];
    final iterations = parameters['iterations'];
    final saltBase64 = parameters['salt'];

    if (kdf != keyDerivationFunction || iterations is! int || iterations <= 0 || saltBase64 is! String) {
      throw FormatException('The encryption parameters of the export are not supported: $kdf, $iterations');
    }

    final salt = base64.decode(saltBase64);
    final key = await Isolate.run(() => _deriveKey(password, salt, iterations));

    return _encrypter(Key(key));
  }

  /// Returns the encrypter of the exports made before version 2.4.0, whose key is the [password] itself.
  ///
  /// Throws a [FormatException] if the [password] isn't exactly 32 bytes long.
  Encrypter legacyEncrypter(String password) {
    final key = Key.fromUtf8(password);

    if (key.length != _keyLength) {
      throw FormatException('The password of an export before 2.4.0 must be 32 bytes long, not ${key.length}');
    }

    return _encrypter(key);
  }

  /// Returns the AES CBC encrypter with the [key].
  Encrypter _encrypter(Key key) => Encrypter(AES(key, mode: AESMode.cbc));

  /// Extracts the initialization vector and the cipher from the [encryptedText].
  ///
  /// The initialization vector is stored in the first 24 characters of the [encryptedText].
  /// The rest of the [encryptedText] corresponds to the cipher.
  (IV, String) extractIvAndCipher(String encryptedText) {
    final ivBase64 = encryptedText.substring(0, 24);
    final iv = IV.fromBase64(ivBase64);

    final cipherBase64 = encryptedText.substring(24);

    return (iv, cipherBase64);
  }

  /// Encrypts the [text] with the [encrypter], with a new random initialization vector.
  String encrypt(Encrypter encrypter, String text) {
    final iv = IV.fromSecureRandom(16);
    final cipher = encrypter.encrypt(text, iv: iv);

    return iv.base64 + cipher.base64;
  }

  /// Decrypts the [text] with the [encrypter].
  String decrypt(Encrypter encrypter, String text) {
    final ivAndCipher = extractIvAndCipher(text);

    return encrypter.decrypt64(ivAndCipher.$2, iv: ivAndCipher.$1);
  }
}

/// Derives a key from the [password] with PBKDF2-HMAC-SHA256, the [salt] and the number of [iterations].
Uint8List _deriveKey(String password, Uint8List salt, int iterations) {
  final derivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
    ..init(Pbkdf2Parameters(salt, iterations, EncryptionUtils._keyLength));

  return derivator.process(Uint8List.fromList(utf8.encode(password)));
}
