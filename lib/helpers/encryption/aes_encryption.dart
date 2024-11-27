import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';

const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';

String _randomString(int length) {
  final random = Random.secure();
  final result = StringBuffer();
  for (var i = 0; i < length; i++) {
    result.write(chars[random.nextInt(chars.length)]);
  }
  return result.toString();
}

_getSecretKeyString() {
  return _randomString(32);
}

_getIVString() {
  return _randomString(16);
}

class AESEncryption {
  final Key key;
  final IV iv;

  AESEncryption()
      : key = Key.fromUtf8(_getSecretKeyString()),
        iv = IV.fromUtf8(_getIVString());

  AESEncryption.fromKeyAndIV(String key, String iv)
      : key = Key.fromUtf8(key),
        iv = IV.fromUtf8(iv);

  String encryptAES(String data) {
    try {
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
      final encrypted = encrypter.encrypt(data, iv: iv);
      return encrypted.base64;
    } catch (error) {
      throw Exception('No se pudo encriptar la información: $error');
    }
  }

  String decryptAES(String encryptedData) {
    try {
      final encrypter =
          Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
      final decrypted =
          encrypter.decrypt(Encrypted.fromBase64(encryptedData), iv: iv);
      return decrypted;
    } catch (error) {
      throw Exception('No se pudo desencriptar la información: $error');
    }
  }

  String getKey() {
    return utf8.decode(key.bytes);
  }

  String getIV() {
    return utf8.decode(iv.bytes);
  }
}
