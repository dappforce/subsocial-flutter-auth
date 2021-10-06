import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_account.freezed.dart';

/// [AuthAccount] represents an account
@freezed
class AuthAccount with _$AuthAccount {
  /// Creates [AuthAccount]
  const factory AuthAccount({
    /// A name that used only locally to identify the account.
    required String localName,

    /// The public key of this account.
    required String publicKey,

    /// Contains the information used to d/encrypt the suri.
    required AccountSecret accountSecret,
  }) = _AuthAccount;
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
}
