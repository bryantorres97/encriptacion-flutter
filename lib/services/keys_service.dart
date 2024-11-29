import 'package:dio/dio.dart';
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

class KeysService {
  static Future<String> getPublicKey() async {
    final response = await dio.get('/business/public-key');
    return response.data;
  }

  static Future<String> getPrivateKey() async {
    final response = await dio.get('/business/private-key');
    return response.data;
  }
}
