import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show compute, visibleForTesting;
import 'package:pointycastle/key_derivators/argon2.dart'
    show Argon2BytesGenerator;
import 'package:pointycastle/pointycastle.dart' show Argon2Parameters;
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

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
    return compute(argon2Hash, parameters.toMap());
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
        config: parameters.config,
      ),
    );
    return const DeepCollectionEquality()
        .equals(resultHash, parameters.expectedHash);
  }

  /// Encrypts [plain] using [key] using [AES] algorithm
  Future<Uint8List> encrypt(EncryptParameters parameters) async {
    return compute(aesEncrypt, parameters.toMap());
  }

  /// Decrypts [plain] using [key] using [AES] algorithm
  Future<Uint8List> decrypt(DecryptParameters parameters) async {
    return compute(aesDecrypt, parameters.toMap());
  }
}

///////////////////////////
//// Isolate functions ////
///////////////////////////

/// Argon2 Hashing
/// [args['config']] must be generated from [Argon2Parameters]
@visibleForTesting
Uint8List argon2Hash(Map<String, dynamic> args) {
  final hashParameters = HashParameters.fromMap(args);
  final config = hashParameters.config as Argon2SecretConfig;

  final Argon2Parameters parameters = Argon2Parameters(
    config.type,
    hashParameters.salt,
    version: config.version,
    iterations: config.iterations,
    memoryPowerOf2: config.memoryCost,
    lanes: config.lanes,
    desiredKeyLength: hashParameters.outputLength,
  );

  final gen = Argon2BytesGenerator();

  gen.init(parameters);

  final hashBytes = gen.process(hashParameters.plain);

  return hashBytes;
}

/// AES Encryption
/// [args['config']] must be generated from [DefaultAesSecretConfig]
@visibleForTesting
Future<Uint8List> aesEncrypt(Map<String, dynamic> args) async {
  final parameters = EncryptParameters.fromMap(args);
  final config = parameters.config as DefaultAesSecretConfig;

  final iv = IV.fromLength(16);
  final encryptor = Encrypter(AES(Key(parameters.key)));
  final encrypted = encryptor.encryptBytes(parameters.plain, iv: iv);
  return encrypted.bytes;
}

/// AES Decryption
/// [args['config']] must be generated from [DefaultAesSecretConfig]
@visibleForTesting
Future<Uint8List> aesDecrypt(Map<String, dynamic> args) async {
  final parameters = DecryptParameters.fromMap(args);
  final config = parameters.config as DefaultAesSecretConfig;

  final iv = IV.fromLength(16);
  final encryptor = Encrypter(AES(Key(parameters.key)));
  final decrypted =
      encryptor.decryptBytes(Encrypted(parameters.cipher), iv: iv);
  return Uint8List.fromList(decrypted);
}
