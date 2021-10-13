import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_flutter_auth/src/crypto.dart';
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

import 'models/secret_config_test.dart';

void main() {
  test('generateRandomBytes', () {
    final crypto = Crypto();
    final bytes1 = crypto.generateRandomBytes(100);
    final bytes2 = crypto.generateRandomBytes(100);
    expect(bytes1, isNot(bytes2));
  });

  group(
      'test hash verifyHash with all hashing configs [len: ${hashingConfigs.length}]',
      () {
    int i = 1;
    for (final config in hashingConfigs) {
      test('${i++} config ${config.toMap()}', () async {
        final crypto = Crypto();
        final plainBytes =
            Uint8List.fromList(utf8.encode('Hello this is a Test'));
        final saltBytes = SecureRandom(16).bytes;
        const outputLength = 32;

        final hashedBytes = await crypto.hash(HashParameters(
          plain: plainBytes,
          salt: saltBytes,
          outputLength: outputLength,
          config: config,
        ));

        expect(hashedBytes.length, equals(outputLength));

        final verifyResultTrue = await crypto.verifyHash(VerifyHashParameters(
          plain: plainBytes,
          expectedHash: hashedBytes,
          salt: saltBytes,
          config: config,
        ));

        expect(verifyResultTrue, equals(true));

        final verifyResultNotTheSamePlain =
            await crypto.verifyHash(VerifyHashParameters(
          plain: Uint8List.fromList(utf8.encode('not the plain')),
          expectedHash: hashedBytes,
          salt: saltBytes,
          config: config,
        ));

        expect(verifyResultNotTheSamePlain, equals(false));

        final verifyResultNotTheSameSalt =
            await crypto.verifyHash(VerifyHashParameters(
          plain: plainBytes,
          expectedHash: hashedBytes,
          salt: SecureRandom(16).bytes, // not same salt
          config: config,
        ));

        expect(verifyResultNotTheSameSalt, equals(false));
      });
    }
  });

  group(
      'test encrypt decrypt with all encryption configs [len: ${encryptionConfigs.length}]',
      () {
    int i = 1;
    for (final encryptionConfig in encryptionConfigs) {
      test('${i++} config ${encryptionConfig.toMap()}', () async {
        final crypto = Crypto();
        final plainBytes =
            Uint8List.fromList(utf8.encode('Encryption Plain Text Test'));
        const keyLength = 32;

        final passwordBytes = Uint8List.fromList(utf8.encode('1235432'));
        final passwordSaltBytes = SecureRandom(16).bytes;

        // drive the aes key
        final key = await crypto.hash(HashParameters(
          plain: passwordBytes,
          salt: passwordSaltBytes,
          outputLength: keyLength,
          config: AccountSecretConfig.defaultConfig().keyDerivationConfig,
        ));

        final encryptedBytes = await crypto.encrypt(EncryptParameters(
          key: key,
          plain: plainBytes,
          config: encryptionConfig,
        ));

        expect(encryptedBytes, isNot(equals(plainBytes)));

        final decryptedBytes = await crypto.decrypt(DecryptParameters(
          key: key,
          cipher: encryptedBytes,
          config: encryptionConfig,
        ));

        expect(decryptedBytes, equals(plainBytes));
      });
    }
  });

  ///// Isolate function tests

  Future<void> genericHashTest({
    required HashingSecretConfig config,
    required FutureOr<Uint8List> Function(Map<String, dynamic> args) hashFn,
  }) async {
    final plainBytes = Uint8List.fromList(utf8.encode('Hello this is a Test'));
    final saltBytes = SecureRandom(16).bytes;
    const outputLength = 32;

    final hashedBytes = await hashFn(HashParameters(
      plain: plainBytes,
      salt: saltBytes,
      outputLength: outputLength,
      config: config,
    ).toMap());

    expect(hashedBytes.length, equals(outputLength));
  }

  group('argon2', () {
    test('hash would run if config is correct', () {
      for (final config in hashingConfigs) {
        expect(
          () => genericHashTest(
            config: config,
            hashFn: argon2Hash,
          ),
          config is Argon2SecretConfig ? returnsNormally : throwsA(anything),
        );
      }
    });
  });
}
