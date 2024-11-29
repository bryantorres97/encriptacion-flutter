import 'dart:convert';

import 'package:encryption_data_app/core/entities/body_encrypted.dart';
import 'package:encryption_data_app/helpers/encryption/encryption.dart';

class HttpEncryption {
  static Future<Map<String, dynamic>> decrypt(BodyEncripted data) async {
    final decryptedSessionKey = await RSAEncryption.decrypt(data.sessionKey);
    final decryptedIv = await RSAEncryption.decrypt(data.iv);

    final aes = AESEncryption.fromKeyAndIV(decryptedSessionKey, decryptedIv);

    final decryptedData = aes.decryptAES(data.data);

    return jsonDecode(decryptedData);
  }

  static Future<BodyEncripted> encrypt(Map<String, dynamic> data) async {
    final bodyString = jsonEncode(data);
    final aesToEncrypt = AESEncryption();
    final secretKey = aesToEncrypt.getKey();
    final ivToEncrypt = aesToEncrypt.getIV();
    final encryptedBody = aesToEncrypt.encryptAES(bodyString);

    final encryptedIv = await RSAEncryption.encrypt(ivToEncrypt);
    final encryptedKey = await RSAEncryption.encrypt(secretKey);

    return BodyEncripted(
      data: encryptedBody,
      sessionKey: encryptedKey,
      iv: encryptedIv,
    );
  }
}
