import 'package:dio/dio.dart';
import 'package:encryption_data_app/core/entities/body_encrypted.dart';
import 'package:encryption_data_app/helpers/encryption/encryption.dart';
import 'package:encryption_data_app/helpers/encryption/http_encryption.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
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

    final encryptedData = response.data['Data'];
    final aes = AESEncryption.fromKeyAndIV(decriptedSessionKey, decriptedIv);

    final decryptedData = aes.decryptAES(encryptedData);

    return decryptedData;
  }

  static Future<Map<String, dynamic>> getAccounts2() async {
    
    final Map<String, String> body = {"cliIdentificacion": "1804388559"};
    final dataEncripted = await HttpEncryption.encrypt(body);
    final data = dataEncripted.toJson();

    logger.t(
      "Enviando petición",
    );
    final response = await dio.post('/business/client-info2', data: data);
    logger.t("Petición completada");
    final bodyEncripted = BodyEncripted.fromJson(response.data);
    final result = await HttpEncryption.decrypt(bodyEncripted);
  
    return result;
  }
}
