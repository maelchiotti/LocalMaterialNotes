import 'package:encrypt/encrypt.dart';
import 'package:localmaterialnotes/utils/preferences/preference_key.dart';
import 'package:localmaterialnotes/utils/preferences/preferences_utils.dart';

class EncryptionUtils {
  Future<Encrypter> get encrypter async {
    final password = await PreferencesUtils().getSecure(PreferenceKey.encryptionPassword);

    if (password == null || password.isEmpty) {
      throw Exception('The password for the encryption is not set');
    }

    final key = Key.fromUtf8(password);

    return Encrypter(AES(key));
  }

  Future<IV> get initVector async {
    final initVectorBase64 = await PreferencesUtils().getSecure(PreferenceKey.encryptionInitVector);

    if (initVectorBase64 == null || initVectorBase64.isEmpty) {
      throw Exception('The initialization vector for the encryption is not set');
    }

    return IV.fromBase64(initVectorBase64);
  }

  Future<String> encrypt(String text) async {
    return (await encrypter).encrypt(text, iv: await initVector).base64;
  }

  Future<String> decrypt(String text) async {
    return (await encrypter).decrypt64(text, iv: await initVector);
  }
}
