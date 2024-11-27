import 'package:encryption_data_app/helpers/encryption/encryption.dart';
import 'package:encryption_data_app/services/accounts_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: Center(
            child: Column(
          children: [
            FilledButton(
                onPressed: () async {
                  const textToEncript = 'Hola mundo';
                  final encryptedText =
                      await RSAEncryption.encrypt(textToEncript);
                  logger.i('Texto encriptado: $encryptedText');

                  final decryptedText =
                      await RSAEncryption.decrypt(encryptedText);
                  logger.i('Texto desencriptado: $decryptedText');
                },
                child: const Text('Pruebas')),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () async {
                  final decryptedData = await AccountsService.getAccounts();

                  logger.d('Data: $decryptedData');
                },
                child: const Text('Obtener cuentas')),
            const SizedBox(height: 20),
            FilledButton(
                onPressed: () async {
                  final decryptedData = await AccountsService.getAccounts2();

                  logger.d('Data: $decryptedData');
                },
                child: const Text('Obtener cuentas 2')),
          ],
        )),
      ),
    );
  }
}
