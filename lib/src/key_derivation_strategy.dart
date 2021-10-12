import 'dart:typed_data';

import 'package:subsocial_flutter_auth/src/crypto.dart';
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';

/// [KeyDerivationStrategy] provides a method to drive encryption keys.
class KeyDerivationStrategy {
  final Crypto _crypto;

  /// Creates [KeyDerivationStrategy]
  KeyDerivationStrategy(this._crypto);

  /// Drive an encryption key of length [length] from a [password] and a [salt]
  Future<Uint8List> driveKey(int length, Uint8List password, Uint8List salt) {
    return _crypto.hash(HashParameters(
      plain: password,
      salt: salt,
      outputLength: length,
    ));
  }
}
