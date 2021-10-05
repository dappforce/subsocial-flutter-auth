import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'auth_account.freezed.dart';
part 'auth_account.g.dart';

// This class is workaround this issue, this class will force generate from freezed file
// https://github.com/hivedb/hive/issues/795
@freezed
class _Dummy with _$_Dummy {
  const factory _Dummy() = __Dummy;
  factory _Dummy.fromJson(Map<String, dynamic> json) => _$_DummyFromJson(json);
}

/// [AuthAccount] represents an account
@freezed
class AuthAccount with _$AuthAccount {
  /// Creates [AuthAccount]
  @HiveType(typeId: 1)
  const factory AuthAccount({
    /// A name that used only locally to identify the account.
    @HiveField(0) required String localName,

    /// The public key of this account.
    @HiveField(1) required String publicKey,

    /// Contains the information used to d/encrypt the suri.
    @HiveField(2) required AccountSecret accountSecret,
  }) = _AuthAccount;
}

/// [AccountSecret] contains the information used to d/encrypt the suri.
@freezed
class AccountSecret with _$AccountSecret {
  const AccountSecret._();

  /// Creates [AccountSecret]
  @HiveType(typeId: 2)
  const factory AccountSecret({
    /// The encrypted suri.
    @HiveField(0) required Uint8List encryptedSuri,

    /// Salt used to drive the encryption key from password.
    @HiveField(1) required Uint8List encryptionKeySalt,

    /// Hash used to verify the password.
    @HiveField(2) required Uint8List passwordHash,

    /// Salt used to hash the password.
    @HiveField(3) required Uint8List passwordSalt,
  }) = _AccountSecret;
}
