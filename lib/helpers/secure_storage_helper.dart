import 'package:flutter_secure_storage/flutter_secure_storage.dart';

AndroidOptions _getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );

final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

class SecureStorageHelper {
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<Map<String, String>?> readAll() async {
    return await _storage.readAll();
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  static Future<void> write(
      {required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }
}
