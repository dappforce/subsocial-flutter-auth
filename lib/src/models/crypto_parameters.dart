import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:subsocial_auth/src/crypto.dart';
import 'package:subsocial_auth/src/models/secret_config.dart';

/// Parameters used in [Crypto.hash]
@immutable
class HashParameters {
  /// Plain data to be hashed
  final Uint8List plain;

  /// Hashing salt
  final Uint8List salt;

  /// The result length
  final int outputLength;

  /// Hashing config
  final HashingSecretConfig config;

  /// Create [HashParameters]
  const HashParameters({
    required this.plain,
    required this.salt,
    required this.outputLength,
    required this.config,
  });

  /// Convert [Map] to [HashParameters].
  factory HashParameters.fromMap(Map<String, dynamic> map) {
    return HashParameters(
      plain: map['plain']! as Uint8List,
      salt: map['salt']! as Uint8List,
      outputLength: map['outputLength']! as int,
      config: HashingSecretConfig.fromMap(
        map['config']! as Map<String, dynamic>,
      ),
    );
  }

  /// Convert [HashParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'plain': plain,
      'salt': salt,
      'outputLength': outputLength,
      'config': config.toMap(),
    };
  }

  List<Object?> get _props => [plain, salt, outputLength, config];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HashParameters &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}

/// Parameters used in [Crypto.verifyHash]
@immutable
class VerifyHashParameters {
  /// Plain data to be checked
  final Uint8List plain;

  /// The expected hashing result of hashing the [plain] data
  final Uint8List expectedHash;

  /// Hashing salt
  final Uint8List salt;

  /// Hashing config
  final HashingSecretConfig config;

  /// Create [VerifyHashParameters]
  const VerifyHashParameters({
    required this.plain,
    required this.expectedHash,
    required this.salt,
    required this.config,
  });

  /// Convert [Map] to [VerifyHashParameters].
  factory VerifyHashParameters.fromMap(Map<String, dynamic> map) {
    return VerifyHashParameters(
      plain: map['plain']! as Uint8List,
      expectedHash: map['expectedHash']! as Uint8List,
      salt: map['salt']! as Uint8List,
      config: HashingSecretConfig.fromMap(
        map['config']! as Map<String, dynamic>,
      ),
    );
  }

  /// Convert [VerifyHashParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'plain': plain,
      'expectedHash': expectedHash,
      'salt': salt,
      'config': config.toMap(),
    };
  }

  List<Object?> get _props => [plain, expectedHash, salt, config];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerifyHashParameters &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}

/// Parameters used in [Crypto.encrypt]
@immutable
class EncryptParameters {
  /// Encryption key
  final Uint8List key;

  /// Plain data
  final Uint8List plain;

  /// Encryption config
  final EncryptionSecretConfig config;

  /// Creates [EncryptParameters]
  const EncryptParameters({
    required this.key,
    required this.plain,
    required this.config,
  });

  /// Convert [Map] to [EncryptParameters].
  factory EncryptParameters.fromMap(Map<String, dynamic> map) {
    return EncryptParameters(
      key: map['key']! as Uint8List,
      plain: map['plain']! as Uint8List,
      config: EncryptionSecretConfig.fromMap(
        map['config']! as Map<String, dynamic>,
      ),
    );
  }

  /// Convert [EncryptParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'plain': plain,
      'config': config.toMap(),
    };
  }

  List<Object?> get _props => [key, plain, config];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncryptParameters &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}

/// Parameters used in [Crypto.encrypt]
@immutable
class DecryptParameters {
  /// Decryption key
  final Uint8List key;

  /// Encrypted data
  final Uint8List cipher;

  /// Encryption config
  final EncryptionSecretConfig config;

  /// Creates [DecryptParameters]
  const DecryptParameters({
    required this.key,
    required this.cipher,
    required this.config,
  });

  /// Convert [Map] to [DecryptParameters].
  factory DecryptParameters.fromMap(Map<String, dynamic> map) {
    return DecryptParameters(
      key: map['key']! as Uint8List,
      cipher: map['cipher']! as Uint8List,
      config: EncryptionSecretConfig.fromMap(
        map['config']! as Map<String, dynamic>,
      ),
    );
  }

  /// Convert [DecryptParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'cipher': cipher,
      'config': config.toMap(),
    };
  }

  List<Object?> get _props => [key, cipher, config];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DecryptParameters &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}
