import 'dart:convert';
import 'dart:typed_data';

import 'package:subsocial_flutter_auth/src/crypto.dart';

import 'models/auth_account.dart';

/// [AccountSecretFactory] provides methods to construct [AccountSecret] using
/// [Crypto]
class AccountSecretFactory {
  final Crypto _crypto;
  final int _passwordSaltLength;
  final int _encryptionKeySaltLength;
  final int _encryptionKeyLength;

  /// Creates [AccountSecretFactory].
  AccountSecretFactory(
    this._crypto, {
    int passwordSaltLength = 16,
    int encryptionKeySaltLength = 16,
    int encryptionKeyLength = 32,
  })  : _passwordSaltLength = passwordSaltLength,
        _encryptionKeySaltLength = encryptionKeySaltLength,
        _encryptionKeyLength = encryptionKeyLength;

  /// Creates [AccountSecret] from plain password string and suri string
  Future<AccountSecret> createFromPlainString({
    required String password,
    required String suri,
  }) async =>
      createFromPlainBytes(
        password: Uint8List.fromList(utf8.encode(password)),
        suri: Uint8List.fromList(utf8.encode(suri)),
      );

  /// Creates [AccountSecret] from plain password bytes and suri bytes
  Future<AccountSecret> createFromPlainBytes({
    required Uint8List password,
    required Uint8List suri,
  }) async {
    final passwordSalt = _crypto.generateRandomBytes(
      _passwordSaltLength,
    );
    final encryptionKeySalt = _crypto.generateRandomBytes(
      _encryptionKeySaltLength,
    );
    final encryptionKey = await _driveEncryptionKey(password, passwordSalt);
    final encryptedSuri = await _crypto.encrypt(
      key: encryptionKey,
      plain: suri,
    );
    final passwordHash = await _crypto.hash(
      plain: password,
      salt: passwordSalt,
      outputLength: 32,
    );
    return AccountSecret(
      encryptedSuri: encryptedSuri,
      passwordHash: passwordHash,
      passwordSalt: passwordSalt,
      encryptionKeySalt: encryptionKeySalt,
    );
  }

  Future<Uint8List> _driveEncryptionKey(Uint8List password, Uint8List salt) {
    return _crypto.hash(
      plain: password,
      salt: salt,
      outputLength: _encryptionKeyLength,
    );
  }
}
