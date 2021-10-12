import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_flutter_auth/src/crypto.dart';
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';

void main() {
  test('test hash verifyHash', () async {
    final crypto = Crypto();
    final plainBytes = Uint8List.fromList(utf8.encode('Hello this is a Test'));
    final saltBytes = SecureRandom(16).bytes;
    const outputLength = 32;

    final hashedBytes = await crypto.hash(HashParameters(
      plain: plainBytes,
      salt: saltBytes,
      outputLength: outputLength,
    ));

    expect(hashedBytes.length, equals(outputLength));

    final verifyResultTrue = await crypto.verifyHash(VerifyHashParameters(
      plain: plainBytes,
      expectedHash: hashedBytes,
      salt: saltBytes,
    ));

    expect(verifyResultTrue, equals(true));

    final verifyResultNotTheSamePlain =
        await crypto.verifyHash(VerifyHashParameters(
      plain: Uint8List.fromList(utf8.encode('not the plain')),
      expectedHash: hashedBytes,
      salt: saltBytes,
    ));

    expect(verifyResultNotTheSamePlain, equals(false));

    final verifyResultNotTheSameSalt =
        await crypto.verifyHash(VerifyHashParameters(
      plain: plainBytes,
      expectedHash: hashedBytes,
      salt: SecureRandom(16).bytes, // not same salt
    ));

    expect(verifyResultNotTheSameSalt, equals(false));
  });

  test('test encrypt decrypt', () async {
    final crypto = Crypto();
    final plainBytes =
        Uint8List.fromList(utf8.encode('Encryption Plain Text Test'));
    const keyLength = 32;

    final passwordBytes = Uint8List.fromList(utf8.encode('1235432'));
    final passwordSaltBytes = SecureRandom(16).bytes;

    // drive the aes key
    final key = await crypto.hash(HashParameters(
      plain: passwordBytes,
      salt: passwordSaltBytes,
      outputLength: keyLength,
    ));

    final encryptedBytes = await crypto.encrypt(EncryptParameters(
      key: key,
      plain: plainBytes,
    ));

    expect(encryptedBytes, isNot(equals(plainBytes)));

    final decryptedBytes = await crypto.decrypt(DecryptParameters(
      key: key,
      cipher: encryptedBytes,
    ));

    expect(decryptedBytes, equals(plainBytes));
  });
}
