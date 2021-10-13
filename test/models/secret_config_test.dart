import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pointycastle/key_derivators/api.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

import '../utils.dart';

final hashingConfigs = [
  Argon2SecretConfig(
    type: Argon2Parameters.ARGON2_id,
    version: Argon2Parameters.ARGON2_VERSION_10,
    iterations: 2,
    memoryCost: 16,
    lanes: 1,
  ),
  Argon2SecretConfig(
    type: Argon2Parameters.ARGON2_id,
    version: Argon2Parameters.ARGON2_VERSION_13,
    iterations: 2,
    memoryCost: 16,
    lanes: 1,
  ),
].toUnmodifiableListView();

final encryptionConfigs = [
  const DefaultAesSecretConfig(),
].toUnmodifiableListView();

final secretConfigs = [
  ...hashingConfigs,
  ...encryptionConfigs,
].toUnmodifiableListView();

final accountConfigs = hashingConfigs
    .map((sc1) {
      for (final sc2 in hashingConfigs) {
        for (final sc3 in encryptionConfigs) {
          return AccountSecretConfig.internal(
            passwordHashingConfig: sc1,
            keyDerivationConfig: sc2,
            suriEncryptionConfig: sc3,
          );
        }
      }
    })
    .whereNotNull()
    .followedBy([AccountSecretConfig.defaultConfig()])
    .toUnmodifiableListView();

void main() {
  group('AccountSecretConfig', () {
    test('toMap/fromMap', () {
      for (final config in accountConfigs) {
        final convertedMap = config.toMap();
        final convertedConfig = AccountSecretConfig.fromMap(convertedMap);
        expect(convertedConfig, config);
        expect(convertedConfig.toMap(), convertedMap);
        expect(convertedConfig.hashCode, config.hashCode);
      }
    });
  });
  group('SecretConfig', () {
    test('toMap/fromMap', () {
      for (final config in secretConfigs) {
        final convertedMap = config.toMap();
        final convertedConfig = SecretConfig.fromMap(convertedMap);
        expect(convertedConfig, config);
        expect(convertedConfig.toMap(), convertedMap);
        expect(convertedConfig.hashCode, config.hashCode);
      }
    });
  });
}
