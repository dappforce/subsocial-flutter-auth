import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:subsocial_flutter_auth/src/account_secret_store.dart';
import 'package:subsocial_flutter_auth/src/models/account_secret.dart';

const _keyPrefix = 'subsocial_auth_secrets:';

/// Provides a storage for [AccountSecret] backed by [FlutterSecureStorage].
class SecureAccountSecretStore implements AccountSecretStore {
  final FlutterSecureStorage _secureStorage;

  SecureAccountSecretStore._(this._secureStorage);

  /// Constructs [SecureAccountSecretStore]
  factory SecureAccountSecretStore() =>
      SecureAccountSecretStore._(const FlutterSecureStorage());

  /// Constructs [SecureAccountSecretStore] with injected [FlutterSecureStorage]
  /// *** Used for testing *** won't work in release mode
  @visibleForTesting
  factory SecureAccountSecretStore.testing(FlutterSecureStorage secureStorage) {
    SecureAccountSecretStore? instance;
    assert(() {
      instance = SecureAccountSecretStore._(secureStorage);
      return true;
    }());
    return instance!;
  }

  String _key(String key) => '$_keyPrefix$key';

  @override
  Future<void> addSecret(String publicKey, AccountSecret secret) {
    return _secureStorage.write(
      key: _key(publicKey),
      value: secret.toJson(),
    );
  }

  @override
  Future<AccountSecret?> getSecret(String publicKey) async {
    final json = await _secureStorage.read(key: _key(publicKey));
    if (json == null) return null;
    return _AccountSecretMapper.fromJson(json);
  }

  @override
  Future<void> removeSecret(String publicKey) {
    return _secureStorage.delete(key: _key(publicKey));
  }
}

extension _Uint8ListBase64 on Uint8List {
  String toBase64() => base64.encode(this);
  static Uint8List fromBase64(String base64Str) => base64.decode(base64Str);
}

extension _AccountSecretMapper on AccountSecret {
  Map<String, dynamic> toMap() {
    return {
      'encryptedSuri': encryptedSuri.toBase64(),
      'encryptionKeySalt': encryptionKeySalt.toBase64(),
      'passwordHash': passwordHash.toBase64(),
      'passwordSalt': passwordSalt.toBase64(),
    };
  }

  static AccountSecret fromMap(Map<String, dynamic> map) {
    return AccountSecret(
      encryptedSuri:
          _Uint8ListBase64.fromBase64(map['encryptedSuri']! as String),
      encryptionKeySalt:
          _Uint8ListBase64.fromBase64(map['encryptionKeySalt']! as String),
      passwordHash: _Uint8ListBase64.fromBase64(map['passwordHash']! as String),
      passwordSalt: _Uint8ListBase64.fromBase64(map['passwordSalt']! as String),
    );
  }

  String toJson() => json.encode(toMap());

  static AccountSecret fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
