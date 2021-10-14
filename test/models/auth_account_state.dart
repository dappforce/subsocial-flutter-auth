//ignore_for_file: prefer_const_constructors
import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_auth/src/models/auth_account.dart';
import 'package:subsocial_auth/src/models/secret_config.dart';

import '../mocks.dart';

void main() {
  test('==/hashCode', () {
    const localName = 'Tarek';
    const publicKey = '123214dfsfsdf';
    final config = AccountSecretConfig.defaultConfig();

    final obj1 = AuthAccount(
      localName: localName,
      publicKey: publicKey,
      accountSecretConfig: config,
    );

    final obj2 = AuthAccount(
      localName: localName,
      publicKey: publicKey,
      accountSecretConfig: config,
    );

    expect(obj1 == obj2 && obj2 == obj1, isTrue);
    expect(obj1.hashCode == obj2.hashCode, isTrue);

    final obj3 = AuthAccount(
      localName: '123123',
      publicKey: 'fasdasd',
      accountSecretConfig: FakeAccountSecretConfig(),
    );

    expect(obj1 == obj3 || obj3 == obj1, isFalse);
    expect(obj1.hashCode == obj3.hashCode, isFalse);
  });
}
