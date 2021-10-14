import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_auth/src/secure_account_secret_store.dart';

import 'mocks.dart';

void main() {
  test('add/remove/get secret', () async {
    final store = SecureAccountSecretStore.testing(MockSecureStorage());

    final pubSecrets = List.generate(10, (index) {
      return MapEntry(getRandomString(10), genRandomAccountSecret());
    });

    for (final ps in pubSecrets) {
      await store.addSecret(ps.key, ps.value);
    }

    pubSecrets.shuffle();

    for (final ps in pubSecrets) {
      final value = await store.getSecret(ps.key);
      expect(value, ps.value);
    }

    for (final ps in pubSecrets) {
      await store.removeSecret(ps.key);
    }

    for (final ps in pubSecrets) {
      final value = await store.getSecret(ps.key);
      expect(value, null);
    }

    final anotherOne = MapEntry(getRandomString(10), genRandomAccountSecret());

    await store.addSecret(anotherOne.key, anotherOne.value);

    expect(await store.getSecret(anotherOne.key), anotherOne.value);
  });
}
