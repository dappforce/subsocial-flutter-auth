//ignore_for_file: public_member_api_docs
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

@immutable
class AccountSecretConfig {
  final HashingSecretConfig passwordHashingConfig;
  final HashingSecretConfig keyDerivationConfig;
  final EncryptionSecretConfig suriEncryptionConfig;

  @visibleForTesting
  const AccountSecretConfig.internal({
    required this.passwordHashingConfig,
    required this.keyDerivationConfig,
    required this.suriEncryptionConfig,
  });

  factory AccountSecretConfig.defaultConfig() {
    final hashing = Argon2SecretConfig(
      type: 'id',
      version: 0x10,
      iterations: 2,
      memoryCost: 16,
      lanes: 1,
    );
    const encryption = DefaultAesSecretConfig();
    return AccountSecretConfig.internal(
      passwordHashingConfig: hashing,
      keyDerivationConfig: hashing,
      suriEncryptionConfig: encryption,
    );
  }

  factory AccountSecretConfig.fromMap(Map<String, dynamic> map) {
    return AccountSecretConfig.internal(
      passwordHashingConfig:
          SecretConfig.fromMap(map['hashingConfig']! as Map<String, dynamic>)
              as HashingSecretConfig,
      keyDerivationConfig: SecretConfig.fromMap(
              map['keyDerivationConfig']! as Map<String, dynamic>)
          as HashingSecretConfig,
      suriEncryptionConfig: SecretConfig.fromMap(
              map['suriEncryptionConfig']! as Map<String, dynamic>)
          as EncryptionSecretConfig,
    );
  }

  Map<String, dynamic> toMap() => {
        'hashingConfig': passwordHashingConfig.toMap(),
        'keyDerivationConfig': keyDerivationConfig.toMap(),
        'suriEncryptionConfig': suriEncryptionConfig.toMap(),
      };

  List<Object?> get _props => [
        passwordHashingConfig,
        keyDerivationConfig,
        suriEncryptionConfig,
      ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSecretConfig &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}

/// [SecretConfig] represents the config used to get a secret (hash, encryption)
@immutable
abstract class SecretConfig {
  /// Creates [SecretConfig]
  const SecretConfig();

  /// Converts secret config to a [Map].
  Map<String, dynamic> toMap();

  factory SecretConfig.fromMap(Map<String, dynamic> map) {
    final configType = map['configType'];
    switch (configType) {
      case Argon2SecretConfig.configType:
        return Argon2SecretConfig.fromMap(map);
      case DefaultAesSecretConfig.configType:
        return DefaultAesSecretConfig.fromMap(map);
    }
    throw StateError('Config type: "$configType" is not known');
  }

  /// Props used for ==/hashcode
  @protected
  List<Object?> get props;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SecretConfig &&
          const DeepCollectionEquality().equals(props, other.props);

  @override
  int get hashCode =>
      props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}

/// Indicates that this config should be used with hashing
abstract class HashingSecretConfig extends SecretConfig {
  const HashingSecretConfig();

  factory HashingSecretConfig.fromMap(Map<String, dynamic> map) =>
      SecretConfig.fromMap(map) as HashingSecretConfig;
}

/// Indicates that this config should be used with encryption
abstract class EncryptionSecretConfig extends SecretConfig {
  const EncryptionSecretConfig();

  factory EncryptionSecretConfig.fromMap(Map<String, dynamic> map) =>
      SecretConfig.fromMap(map) as EncryptionSecretConfig;
}

//// Hashing / Key derivation

/// Argon2 config
class Argon2SecretConfig extends HashingSecretConfig {
  static const configType = 'argon2';

  /// Argon2 type ['d', 'i', 'id']
  final String type;

  /// Argon2 version [0x10, 0x13]
  final int version;

  /// Argon2 iterations
  final int iterations;

  /// Argon2 memoryCost
  final int memoryCost;

  /// Argon2 lanes
  final int lanes;

  /// Creates [Argon2SecretConfig]
  Argon2SecretConfig({
    required this.type,
    required this.version,
    required this.iterations,
    required this.memoryCost,
    required this.lanes,
  })  : assert(['d', 'i', 'id'].contains(type)),
        assert([0x13, 0x10].contains(version));

  factory Argon2SecretConfig.fromMap(Map<String, dynamic> map) {
    if (map['configType'] != configType) {
      throw ArgumentError.value(
        map,
        'cannot be converted to $Argon2SecretConfig',
      );
    }
    return Argon2SecretConfig(
      type: map['type']! as String,
      version: map['version']! as int,
      iterations: map['iterations']! as int,
      memoryCost: map['memoryCost']! as int,
      lanes: map['lanes']! as int,
    );
  }

  @override
  Map<String, dynamic> toMap() => {
        'configType': configType,
        'type': type,
        'version': version,
        'iterations': iterations,
        'memoryCost': memoryCost,
        'lanes': lanes,
      };

  @override
  List<Object?> get props => [type, version, iterations, memoryCost, lanes];
}

//// Encryption / Decryption

class DefaultAesSecretConfig extends EncryptionSecretConfig {
  static const configType = 'default_aes';

  /// Creates [DefaultAesSecretConfig]
  const DefaultAesSecretConfig();

  factory DefaultAesSecretConfig.fromMap(Map<String, dynamic> map) {
    if (map['configType'] != configType) {
      throw ArgumentError.value(
        map,
        'cannot be converted to $DefaultAesSecretConfig',
      );
    }
    return const DefaultAesSecretConfig();
  }

  @override
  Map<String, dynamic> toMap() => {
        'configType': configType,
      };

  @override
  List<Object?> get props => [];
}
