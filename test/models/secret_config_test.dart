import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

void main() {
  test('toMap/fromMap', () {
    final configsToTest = [
      Argon2SecretConfig.defaultConfig(),
      DefaultAesSecretConfig.defaultConfig(),
      const DefaultAesSecretConfig(),
      Argon2SecretConfig(
        type: 'id',
        version: 0x10,
        iterations: 2,
        memoryCost: 16,
        lanes: 1,
      ),
    ];

    for (final config in configsToTest) {
      final convertedMap = config.toMap();
      final convertedConfig = SecretConfig.fromMap(convertedMap);
      expect(convertedConfig, config);
      expect(convertedConfig.toMap(), convertedMap);
      expect(convertedConfig.hashCode, config.hashCode);
    }
  });
}
