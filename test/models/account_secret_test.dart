import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_flutter_auth/src/models/account_secret.dart';

void main() {
  test('==/hashCode', () {
    final encryptedSuri = SecureRandom(16).bytes;
    final encryptionKeySalt = SecureRandom(16).bytes;
    final passwordHash = SecureRandom(16).bytes;
    final passwordSalt = SecureRandom(16).bytes;

    final obj1 = AccountSecret(
      encryptedSuri: encryptedSuri,
      encryptionKeySalt: encryptionKeySalt,
      passwordHash: passwordHash,
      passwordSalt: passwordSalt,
    );

    final obj2 = AccountSecret(
      encryptedSuri: encryptedSuri,
      encryptionKeySalt: encryptionKeySalt,
      passwordHash: passwordHash,
      passwordSalt: passwordSalt,
    );

    expect(obj1 == obj2 && obj2 == obj1, isTrue);
    expect(obj1.hashCode == obj2.hashCode, isTrue);

    final obj3 = AccountSecret(
      encryptedSuri: SecureRandom(16).bytes,
      encryptionKeySalt: SecureRandom(16).bytes,
      passwordHash: SecureRandom(16).bytes,
      passwordSalt: SecureRandom(16).bytes,
    );

    expect(obj1 == obj3 || obj3 == obj1, isFalse);
    expect(obj1.hashCode == obj3.hashCode, isFalse);
  });
}
