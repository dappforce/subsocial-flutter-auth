import 'dart:typed_data';

import 'package:subsocial_flutter_auth/src/crypto.dart';

/// [KeyDerivationStrategy] provides a method to drive encryption keys.
abstract class KeyDerivationStrategy {
  /// Drive an encryption key of length [length] from a [password] and a [salt]
  Future<Uint8List> driveKey(int length, Uint8List password, Uint8List salt);
}

/// [DefaultKeyDerivationStrategy] provides the default method to drive a key
/// using the [Crypto.hash].
class DefaultKeyDerivationStrategy implements KeyDerivationStrategy {
  final Crypto _crypto;

  /// Creates [KeyDerivationStrategy]
  DefaultKeyDerivationStrategy(this._crypto);

  @override
  Future<Uint8List> driveKey(int length, Uint8List password, Uint8List salt) {
    return _crypto.hash(
      plain: password,
      salt: salt,
      outputLength: length,
    );
  }
}
