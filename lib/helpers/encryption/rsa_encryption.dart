import 'dart:io';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:encryption_data_app/helpers/secure_storage_helper.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAEncryption {
  /// Escribe contenido en un archivo temporal.
  ///
  /// [content] es el contenido que se escribirá en el archivo.
  /// [fileName] es el nombre del archivo temporal.
  ///
  /// Devuelve un `Future<File>` que se completa con el archivo creado.
  static Future<File> _writeTempFile(String content, String fileName) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/$fileName');
    await tempFile.writeAsString(content);
    return tempFile;
  }

  static Future<bool> _existsTempFile(String fileName) async {
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/$fileName');
    return tempFile.exists();
  }

  static Future<File> _getTempFile(String fileName) async {
    final tempDir = Directory.systemTemp;
    return File('${tempDir.path}/$fileName');
  }

  static Future<RSAPublicKey> _getStoredPublicKey() async {
    final File publicKeyFile;
    final existsTempFile = await _existsTempFile('public.pem');
    if (existsTempFile) {
      publicKeyFile = await _getTempFile('public.pem');
    } else {
      final publicKeyString = await SecureStorageHelper.read('ch_public_key');
      publicKeyFile = await _writeTempFile(publicKeyString!, 'public.pem');
    }

    return parseKeyFromFile<RSAPublicKey>(publicKeyFile.path);
  }

  static Future<RSAPrivateKey> _getStoredPrivateKey() async {
    final File privateKeyFile;
    final existsTempFile = await _existsTempFile('private.pem');
    if (existsTempFile) {
      privateKeyFile = await _getTempFile('private.pem');
    } else {
      final privateKeyString = await SecureStorageHelper.read('ch_private_key');
      privateKeyFile = await _writeTempFile(privateKeyString!, 'private.pem');
    }

    return parseKeyFromFile<RSAPrivateKey>(privateKeyFile.path);
  }

  static Future<String> encrypt(String plainText) async {
    final publicKey = await _getStoredPublicKey();
    final privKey = await _getStoredPrivateKey();
    final rsa = RSA(
        publicKey: publicKey, privateKey: privKey, encoding: RSAEncoding.OAEP);

    final encrypter = Encrypter(rsa);
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }

  static Future<String> decrypt(String encryptedText) async {
    final publicKey = await _getStoredPublicKey();
    final privKey = await _getStoredPrivateKey();
    final rsa = RSA(
        publicKey: publicKey, privateKey: privKey, encoding: RSAEncoding.OAEP);

    final encrypter = Encrypter(rsa);

    final encrypted = Encrypted.fromBase64(encryptedText);
    return encrypter.decrypt(encrypted);
  }
}
