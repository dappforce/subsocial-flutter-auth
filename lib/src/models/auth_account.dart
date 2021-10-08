import 'dart:convert' as c;
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_account.freezed.dart';

/// [AuthAccount] represents an account
@freezed
class AuthAccount with _$AuthAccount {
  const AuthAccount._();

  /// Creates [AuthAccount]
  const factory AuthAccount({
    /// A name that used only locally to identify the account.
    required String localName,

    /// The public key of this account.
    required String publicKey,

    /// Contains the information used to d/encrypt the suri.
    required AccountSecret accountSecret,
  }) = _AuthAccount;

  @override
  String toString() {
    return '''AuthAccount(
  localName: $localName,
  publicKey: $publicKey,
  accountSecret: ${accountSecret.toString().replaceAll('\n', '\n\t')}
)
''';
  }
}

extension on Uint8List {
  String get base64 => c.base64.encode(this);
}

/// [AccountSecret] contains the information used to d/encrypt the suri.
@freezed
class AccountSecret with _$AccountSecret {
  const AccountSecret._();

  /// Creates [AccountSecret]
  const factory AccountSecret({
    /// The encrypted suri.
    required Uint8List encryptedSuri,

    /// Salt used to drive the encryption key from password.
    required Uint8List encryptionKeySalt,

    /// Hash used to verify the password.
    required Uint8List passwordHash,

    /// Salt used to hash the password.
    required Uint8List passwordSalt,
  }) = _AccountSecret;

  @override
  String toString() {
    return '''AccountSecret(
  encryptedSuri: ${encryptedSuri.base64},
  encryptionKeySalt: ${encryptionKeySalt.base64},
  passwordHash: ${passwordHash.base64},
  passwordSalt: ${passwordSalt.base64},
)
''';
  }
}
