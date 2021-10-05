import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' show compute;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pointycastle/key_derivators/argon2.dart';
import 'package:pointycastle/pointycastle.dart';

/// [Crypto] class contains cryptographic operations used in this package.
/// All operations are done in another isolate to not block the UI isolate.
class Crypto {
  /// Hash the given [plain] bytes with [salt] to the desired [outputLength]
  /// Algorithm used: ARGON2id
  Future<Uint8List> hash({
    required Uint8List plain,
    required Uint8List salt,
    required int outputLength,
  }) async {
    return compute(_hash, <String, dynamic>{
      'plain': plain,
      'salt': salt,
      'outputLength': outputLength,
    });
  }

  /// Verify that hashing of [plain] with [salt] will generate a hash equal to [expectedHash]
  /// outputLength will be the length of [expectedHash]
  /// Algorithm used: ARGON2id
  Future<bool> verifyHash({
    required Uint8List plain,
    required Uint8List expectedHash,
    required Uint8List salt,
  }) async {
    return compute(_verifyHash, <String, dynamic>{
      'plain': plain,
      'expectedHash': expectedHash,
      'salt': salt,
    });
  }

  /// Encrypts [plain] using [key] using [AES] algorithm
  Future<Uint8List> encrypt({
    required Uint8List key,
    required Uint8List plain,
  }) async {
    return compute(_encrypt, <String, dynamic>{
      'key': key,
      'plain': plain,
    });
  }

  /// Decrypts [plain] using [key] using [AES] algorithm
  Future<Uint8List> decrypt({
    required Uint8List key,
    required Uint8List cipher,
  }) async {
    return compute(_decrypt, <String, dynamic>{
      'key': key,
      'cipher': cipher,
    });
  }
}

///////////////////////////
//// Isolate functions ////
///////////////////////////

Uint8List _hash(Map<String, dynamic> args) {
  final plain = args['plain']! as Uint8List;
  final salt = args['salt']! as Uint8List;
  final outputLength = args['outputLength']! as int;

  final Argon2Parameters parameters = Argon2Parameters(
    Argon2Parameters.ARGON2_id,
    salt,
    version: Argon2Parameters.ARGON2_VERSION_10,
    iterations: 2,
    memoryPowerOf2: 16,
    desiredKeyLength: outputLength,
  );

  final gen = Argon2BytesGenerator();

  gen.init(parameters);

  final hashBytes = gen.process(plain);

  return hashBytes;
}

bool _verifyHash(Map<String, dynamic> args) {
  final plain = args['plain']! as Uint8List;
  final expectedHash = args['expectedHash']! as Uint8List;
  final salt = args['salt']! as Uint8List;
  final res =
      _hash(<String, dynamic>{'outputLength': expectedHash.length, ...args});

  return const DeepCollectionEquality().equals(res, expectedHash);
}

Future<Uint8List> _encrypt(Map<String, dynamic> args) async {
  final key = args['key']! as Uint8List;
  final plain = args['plain']! as Uint8List;
  final iv = IV.fromLength(16);
  final encryptor = Encrypter(AES(Key(key)));
  final encrypted = encryptor.encryptBytes(plain, iv: iv);
  return encrypted.bytes;
}

Future<Uint8List> _decrypt(Map<String, dynamic> args) async {
  final key = args['key']! as Uint8List;
  final cipher = args['cipher']! as Uint8List;
  final iv = IV.fromLength(16);
  final encryptor = Encrypter(AES(Key(key)));
  final decrypted = encryptor.decryptBytes(Encrypted(cipher), iv: iv);
  return Uint8List.fromList(decrypted);
}
