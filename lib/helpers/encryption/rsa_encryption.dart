import 'dart:io';
import 'package:flutter/services.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

class RSAEncryption {
  /// Crea un archivo temporal a partir de un recurso de la aplicación.
  ///
  /// [assetPath] es la ruta del archivo dentro del paquete de recursos.
  ///
  /// Devuelve un `Future<File>` que se completa con el archivo temporal creado.
  static Future<File> _createTempFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());
    return tempFile;
  }

  static Future<RSAPublicKey> _getPublicKey() async {
    final publicKeyFile = await _createTempFile('assets/keys/public.pem');
    return parseKeyFromFile<RSAPublicKey>(publicKeyFile.path);
  }

  static Future<RSAPrivateKey> _getPrivateKey() async {
    final privateKeyFile = await _createTempFile('assets/keys/private.pem');
    return parseKeyFromFile<RSAPrivateKey>(privateKeyFile.path);
  }

  static Future<String> encrypt(String plainText) async {
    final publicKey = await _getPublicKey();
    final privKey = await _getPrivateKey();
    final rsa = RSA(
        publicKey: publicKey, privateKey: privKey, encoding: RSAEncoding.OAEP);

    final encrypter = Encrypter(rsa);
    final encrypted = encrypter.encrypt(plainText);
    return encrypted.base64;
  }

  static Future<String> decrypt(String encryptedText) async {
    final publicKey = await _getPublicKey();
    final privKey = await _getPrivateKey();
    final rsa = RSA(
        publicKey: publicKey, privateKey: privKey, encoding: RSAEncoding.OAEP);

    final encrypter = Encrypter(rsa);

    final encrypted = Encrypted.fromBase64(encryptedText);
    return encrypter.decrypt(encrypted);
  }
}
