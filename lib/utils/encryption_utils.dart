import 'package:encrypt/encrypt.dart';

/// Utilities for AES encryption and decryption of strings based on a user provided password.
class EncryptionUtils {
  /// Generates a random initialization vector.
  IV get generateIv {
    return IV.fromSecureRandom(16);
  }

  /// Generates a key based on the user provided [password].
  ///
  /// The [password] must be exactly 32 characters long.
  Key generateKey(String password) {
    if (password.length != 32) {
      throw Exception(
        'The password for AES encryption and decryption must be exactly 32 characters long, not ${password.length}',
      );
    }

    return Key.fromUtf8(password);
  }

  /// Returns the encrypter to perform AES CBC encryption and decryption based on the user provided [password].
  Encrypter getEncrypter(String password) {
    final key = generateKey(password);

    return Encrypter(AES(key, mode: AESMode.cbc));
  }

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

  /// Encrypts the [text] with the user provided [password].
  String encrypt(String password, String text) {
    final encrypter = getEncrypter(password);

    final iv = generateIv;
    final cipher = encrypter.encrypt(text, iv: iv);

    final initVectorAndEncryptedText = iv.base64 + cipher.base64;

    return initVectorAndEncryptedText;
  }

  /// Decrypts the [text] with the user provided [password].
  String decrypt(String password, String text) {
    final encrypter = getEncrypter(password);
    final ivAndCipher = extractIvAndCipher(text);

    return encrypter.decrypt64(ivAndCipher.$2, iv: ivAndCipher.$1);
  }
}
