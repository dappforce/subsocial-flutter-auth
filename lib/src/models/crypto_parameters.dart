import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:subsocial_flutter_auth/src/crypto.dart';

/// Parameters used in [Crypto.hash]
@immutable
class HashParameters {
  /// Plain data to be hashed
  final Uint8List plain;

  /// Hashing salt
  final Uint8List salt;

  /// The result length
  final int outputLength;

  /// Create [HashParameters]
  const HashParameters({
    required this.plain,
    required this.salt,
    required this.outputLength,
  });

  /// Convert [Map] to [HashParameters].
  factory HashParameters.fromMap(Map<String, dynamic> map) {
    return HashParameters(
      plain: map['plain']! as Uint8List,
      salt: map['salt']! as Uint8List,
      outputLength: map['outputLength']! as int,
    );
  }

  /// Convert [HashParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'plain': plain,
      'salt': salt,
      'outputLength': outputLength,
    };
  }

  List<Object?> get _props => [plain, salt, outputLength];

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

  /// Create [VerifyHashParameters]
  const VerifyHashParameters({
    required this.plain,
    required this.expectedHash,
    required this.salt,
  });

  /// Convert [Map] to [VerifyHashParameters].
  factory VerifyHashParameters.fromMap(Map<String, dynamic> map) {
    return VerifyHashParameters(
      plain: map['plain']! as Uint8List,
      expectedHash: map['expectedHash']! as Uint8List,
      salt: map['salt']! as Uint8List,
    );
  }

  /// Convert [VerifyHashParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'plain': plain,
      'expectedHash': expectedHash,
      'salt': salt,
    };
  }

  List<Object?> get _props => [plain, expectedHash, salt];

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

  /// Creates [EncryptParameters]
  const EncryptParameters({
    required this.key,
    required this.plain,
  });

  /// Convert [Map] to [EncryptParameters].
  factory EncryptParameters.fromMap(Map<String, dynamic> map) {
    return EncryptParameters(
      key: map['key']! as Uint8List,
      plain: map['plain']! as Uint8List,
    );
  }

  /// Convert [EncryptParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'plain': plain,
    };
  }

  List<Object?> get _props => [key, plain];

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

  /// Creates [DecryptParameters]
  const DecryptParameters({
    required this.key,
    required this.cipher,
  });

  /// Convert [Map] to [DecryptParameters].
  factory DecryptParameters.fromMap(Map<String, dynamic> map) {
    return DecryptParameters(
      key: map['key']! as Uint8List,
      cipher: map['cipher']! as Uint8List,
    );
  }

  /// Convert [DecryptParameters] to [Map].
  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'cipher': cipher,
    };
  }

  List<Object?> get _props => [key, cipher];

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
