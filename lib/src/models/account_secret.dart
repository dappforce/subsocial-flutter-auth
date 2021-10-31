import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;

/// [AccountSecret] contains the information used to d/encrypt the suri.
@immutable
class AccountSecret {
  /// The encrypted suri.
  final Uint8List encryptedSuri;

  /// Salt used to drive the encryption key from password.
  final Uint8List encryptionKeySalt;

  /// Hash used to verify the password.
  final Uint8List passwordHash;

  /// Salt used to hash the password.
  final Uint8List passwordSalt;

  /// Creates [AccountSecret]
  const AccountSecret({
    required this.encryptedSuri,
    required this.encryptionKeySalt,
    required this.passwordHash,
    required this.passwordSalt,
  });

  List<Object?> get _props =>
      [encryptedSuri, encryptionKeySalt, passwordHash, passwordSalt];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSecret &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}
