import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:pointycastle/key_derivators/argon2.dart'
    show Argon2BytesGenerator;
import 'package:pointycastle/pointycastle.dart' show Argon2Parameters;
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';

/// [Crypto] class contains cryptographic operations used in this package.
/// All operations are done in another isolate to not block the UI isolate.
class Crypto {
  /// Generates random [Uint8List] of length [length].
  Uint8List generateRandomBytes(int length) {
    return SecureRandom(length).bytes;
  }

  /// Hash the given [plain] bytes with [salt] to the desired [outputLength]
  /// Algorithm used: ARGON2id
  Future<Uint8List> hash(HashParameters parameters) async {
    return compute(_hash, parameters.toMap());
  }

  /// Verify that hashing of [plain] with [salt] will generate a hash equal to [expectedHash]
  /// outputLength will be the length of [expectedHash]
  /// Algorithm used: ARGON2id
  Future<bool> verifyHash(VerifyHashParameters parameters) async {
    final resultHash = await hash(
      HashParameters(
        plain: parameters.plain,
        salt: parameters.salt,
        outputLength: parameters.expectedHash.length,
      ),
    );
    return const DeepCollectionEquality()
        .equals(resultHash, parameters.expectedHash);
  }

  /// Encrypts [plain] using [key] using [AES] algorithm
  Future<Uint8List> encrypt(EncryptParameters parameters) async {
    return compute(_encrypt, parameters.toMap());
  }

  /// Decrypts [plain] using [key] using [AES] algorithm
  Future<Uint8List> decrypt(DecryptParameters parameters) async {
    return compute(_decrypt, parameters.toMap());
  }
}

///////////////////////////
//// Isolate functions ////
///////////////////////////

Uint8List _hash(Map<String, dynamic> args) {
  final hashParameters = HashParameters.fromMap(args);

  final Argon2Parameters parameters = Argon2Parameters(
    Argon2Parameters.ARGON2_id,
    hashParameters.salt,
    version: Argon2Parameters.ARGON2_VERSION_10,
    iterations: 2,
    memoryPowerOf2: 16,
    desiredKeyLength: hashParameters.outputLength,
  );

  final gen = Argon2BytesGenerator();

  gen.init(parameters);

  final hashBytes = gen.process(hashParameters.plain);

  return hashBytes;
}

Future<Uint8List> _encrypt(Map<String, dynamic> args) async {
  final parameters = EncryptParameters.fromMap(args);
  final iv = IV.fromLength(16);
  final encryptor = Encrypter(AES(Key(parameters.key)));
  final encrypted = encryptor.encryptBytes(parameters.plain, iv: iv);
  return encrypted.bytes;
}

Future<Uint8List> _decrypt(Map<String, dynamic> args) async {
  final parameters = DecryptParameters.fromMap(args);
  final iv = IV.fromLength(16);
  final encryptor = Encrypter(AES(Key(parameters.key)));
  final decrypted =
      encryptor.decryptBytes(Encrypted(parameters.cipher), iv: iv);
  return Uint8List.fromList(decrypted);
}
