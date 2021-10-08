import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import '../mocks.dart';

extension on Uint8List {
  String get base64 => convert.base64.encode(this);
}

void main() {
  test('toString', () {
    final account = generateRandomMockAccount();
    final secret = account.accountSecret;
    final accountStr = account.toString();
    final secretStr = secret.toString();

    expect(accountStr, contains('localName: ${account.localName}'));
    expect(accountStr, contains('publicKey: ${account.publicKey}'));

    expect(
        accountStr, contains('encryptedSuri: ${secret.encryptedSuri.base64}'));
    expect(accountStr,
        contains('encryptionKeySalt: ${secret.encryptionKeySalt.base64}'));
    expect(accountStr, contains('passwordHash: ${secret.passwordHash.base64}'));
    expect(accountStr, contains('passwordSalt: ${secret.passwordSalt.base64}'));

    expect(
        secretStr, contains('encryptedSuri: ${secret.encryptedSuri.base64}'));
    expect(secretStr,
        contains('encryptionKeySalt: ${secret.encryptionKeySalt.base64}'));
    expect(secretStr, contains('passwordHash: ${secret.passwordHash.base64}'));
    expect(secretStr, contains('passwordSalt: ${secret.passwordSalt.base64}'));
  });
}
