import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:encryption_data_app/helpers/encryption/encryption.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

final options = BaseOptions(
  baseUrl: 'https://cqzvr46w-3000.brs.devtunnels.ms/api',
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
);

final dio = Dio(options);

class AccountsService {
  static Future<String> getAccounts() async {
    final response = await dio.post('/business/client-info',
        data: {"cliIdentificacion": "1804388559"});
    final sessionKey = response.data['SessionKey'];
    final iv = response.data['IV'];
    final decriptedSessionKey = await RSAEncryption.decrypt(sessionKey);
    final decriptedIv = await RSAEncryption.decrypt(iv);
    logger.d('SessionKey: $decriptedSessionKey');
    logger.d('IV: $decriptedIv');

    final encryptedData = response.data['Data'];
    final aes = AESEncryption.fromKeyAndIV(decriptedSessionKey, decriptedIv);

    logger.d('AES Secret: ${aes.getKey()}');
    logger.d('AES IV: ${aes.getIV()}');

    final decryptedData = aes.decryptAES(encryptedData);

    return decryptedData;
  }

  static Future<String> getAccounts2() async {
    final Map<String, String> body = {"cliIdentificacion": "1804388559"};
    final bodyString = jsonEncode(body);

    final aesToEncrypt = AESEncryption();
    final secretKey = aesToEncrypt.getKey();
    final ivToEncrypt = aesToEncrypt.getIV();
    final encryptedBody = aesToEncrypt.encryptAES(bodyString);

    final Map<String, String> data = {
      "data": encryptedBody,
      "iv": await RSAEncryption.encrypt(ivToEncrypt),
      "key": await RSAEncryption.encrypt(secretKey),
    };

    final response = await dio.post('/business/client-info2', data: data);
    final sessionKey = response.data['SessionKey'];
    final iv = response.data['IV'];
    final decriptedSessionKey = await RSAEncryption.decrypt(sessionKey);
    final decriptedIv = await RSAEncryption.decrypt(iv);
    logger.d('SessionKey: $decriptedSessionKey');
    logger.d('IV: $decriptedIv');

    final encryptedData = response.data['Data'];
    final aes = AESEncryption.fromKeyAndIV(decriptedSessionKey, decriptedIv);
    final decryptedData = aes.decryptAES(encryptedData);

    return decryptedData;
  }
}
