import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

final _secretConfigs = [
  const DefaultAesSecretConfig(),
  Argon2SecretConfig(
    type: 'id',
    version: 0x10,
    iterations: 2,
    memoryCost: 16,
    lanes: 1,
  ),
];

final _accountConfigs = _secretConfigs
    .map((sc1) {
      for (final sc2 in _secretConfigs) {
        for (final sc3 in _secretConfigs) {
          if (sc1 != sc2 && sc2 != sc3 && sc3 != sc1) {
            return AccountSecretConfig.internal(
              hashingConfig: sc1,
              keyDerivationConfig: sc2,
              suriEncryptionConfig: sc3,
            );
          }
        }
      }
    })
    .whereType<AccountSecretConfig>()
    .followedBy([AccountSecretConfig.defaultConfig()]);

void main() {
  group('AccountSecretConfig', () {
    test('toMap/fromMap', () {
      for (final config in _accountConfigs) {
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
      for (final config in _secretConfigs) {
        final convertedMap = config.toMap();
        final convertedConfig = SecretConfig.fromMap(convertedMap);
        expect(convertedConfig, config);
        expect(convertedConfig.toMap(), convertedMap);
        expect(convertedConfig.hashCode, config.hashCode);
      }
    });
  });
}
