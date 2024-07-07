import 'package:encrypt/encrypt.dart';

/// Utilities for AES encryption and decryption of strings based on a user provided passphrase.
class EncryptionUtils {
  /// Generates a random initialization vector.
  IV get generateIv {
    return IV.fromSecureRandom(16);
  }

  /// Generates a key based on the user provided [passphrase].
  ///
  /// The [passphrase] must be exactly 32 characters long.
  Key generateKey(String passphrase) {
    if (passphrase.length != 32) {
      throw Exception(
        'The passphrase for AES encryption and decryption must be exactly 32 characters long, not ${passphrase.length}',
      );
    }

    return Key.fromUtf8(passphrase);
  }

  /// Returns the encrypter to perform AES CBC encryption and decryption based on the user provided [passphrase].
  Encrypter getEncrypter(String passphrase) {
    final key = generateKey(passphrase);

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

  /// Encrypts the [text] with the user provided [passphrase].
  String encrypt(String passphrase, String text) {
    final encrypter = getEncrypter(passphrase);

    final iv = generateIv;
    final cipher = encrypter.encrypt(text, iv: iv);

    final initVectorAndEncryptedText = iv.base64 + cipher.base64;

    return initVectorAndEncryptedText;
  }

  /// Decrypts the [text] with the user provided [passphrase].
  String decrypt(String passphrase, String text) {
    final encrypter = getEncrypter(passphrase);
    final ivAndCipher = extractIvAndCipher(text);

    return encrypter.decrypt64(ivAndCipher.$2, iv: ivAndCipher.$1);
  }
}
