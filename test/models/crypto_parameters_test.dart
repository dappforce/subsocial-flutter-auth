import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

Uint8List _rndb(int length) => SecureRandom(length).bytes;

int _rnd(int max) => Random().nextInt(max);

void main() {
  group('HashParameters', () {
    test('==/hashCode', () {
      final plain = _rndb(16);
      final slat = _rndb(16);
      final outputLength = _rnd(255);

      final obj1 = HashParameters(
        plain: plain,
        salt: slat,
        outputLength: outputLength,
        config: AccountSecretConfig.defaultConfig().passwordHashingConfig,
      );

      final obj2 = HashParameters(
        plain: plain,
        salt: slat,
        outputLength: outputLength,
        config: AccountSecretConfig.defaultConfig().passwordHashingConfig,
      );

      expect(obj1 == obj2 && obj2 == obj1, isTrue);
      expect(obj1.hashCode == obj2.hashCode, isTrue);
    });

    test('to/fromMap', () {
      final parameter = HashParameters(
        plain: _rndb(16),
        salt: _rndb(16),
        outputLength: _rnd(255),
        config: AccountSecretConfig.defaultConfig().passwordHashingConfig,
      );

      final map = parameter.toMap();

      final converted = HashParameters.fromMap(map);

      final convertedMap = converted.toMap();

      expect(converted, parameter);
      expect(convertedMap, map);
    });
  });

  group('VerifyHashParameters', () {
    test('==/hashCode', () {
      final plain = _rndb(16);
      final slat = _rndb(16);
      final expectedHash = _rndb(16);

      final obj1 = VerifyHashParameters(
        plain: plain,
        salt: slat,
        expectedHash: expectedHash,
        config: AccountSecretConfig.defaultConfig().passwordHashingConfig,
      );

      final obj2 = VerifyHashParameters(
        plain: plain,
        salt: slat,
        expectedHash: expectedHash,
        config: AccountSecretConfig.defaultConfig().passwordHashingConfig,
      );

      expect(obj1 == obj2 && obj2 == obj1, isTrue);
      expect(obj1.hashCode == obj2.hashCode, isTrue);
    });

    test('to/fromMap', () {
      final parameter = VerifyHashParameters(
        plain: _rndb(16),
        salt: _rndb(16),
        expectedHash: _rndb(16),
        config: AccountSecretConfig.defaultConfig().passwordHashingConfig,
      );

      final map = parameter.toMap();

      final converted = VerifyHashParameters.fromMap(map);

      final convertedMap = converted.toMap();

      expect(converted, parameter);
      expect(convertedMap, map);
    });
  });

  group('EncryptParameters', () {
    test('==/hashCode', () {
      final key = _rndb(16);
      final plain = _rndb(16);

      final obj1 = EncryptParameters(
        key: key,
        plain: plain,
        config: AccountSecretConfig.defaultConfig().suriEncryptionConfig,
      );

      final obj2 = EncryptParameters(
        key: key,
        plain: plain,
        config: AccountSecretConfig.defaultConfig().suriEncryptionConfig,
      );

      expect(obj1 == obj2 && obj2 == obj1, isTrue);
      expect(obj1.hashCode == obj2.hashCode, isTrue);
    });

    test('to/fromMap', () {
      final parameter = EncryptParameters(
        key: _rndb(16),
        plain: _rndb(16),
        config: AccountSecretConfig.defaultConfig().suriEncryptionConfig,
      );

      final map = parameter.toMap();

      final converted = EncryptParameters.fromMap(map);

      final convertedMap = converted.toMap();

      expect(converted, parameter);
      expect(convertedMap, map);
    });
  });

  group('DecryptParameters', () {
    test('==/hashCode', () {
      final key = _rndb(16);
      final cipher = _rndb(16);

      final obj1 = DecryptParameters(
        key: key,
        cipher: cipher,
        config: AccountSecretConfig.defaultConfig().suriEncryptionConfig,
      );

      final obj2 = DecryptParameters(
        key: key,
        cipher: cipher,
        config: AccountSecretConfig.defaultConfig().suriEncryptionConfig,
      );

      expect(obj1 == obj2 && obj2 == obj1, isTrue);
      expect(obj1.hashCode == obj2.hashCode, isTrue);
    });

    test('to/fromMap', () {
      final parameter = DecryptParameters(
        key: _rndb(16),
        cipher: _rndb(16),
        config: AccountSecretConfig.defaultConfig().suriEncryptionConfig,
      );

      final map = parameter.toMap();

      final converted = DecryptParameters.fromMap(map);

      final convertedMap = converted.toMap();

      expect(converted, parameter);
      expect(convertedMap, map);
    });
  });
}
