import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:subsocial_flutter_auth/src/secure_account_secret_store.dart';

import 'mocks.dart';

class _MockSecureStorage extends Mock implements FlutterSecureStorage {
  final Map<String, String> values = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    if (value == null) {
      await delete(key: key);
    } else {
      values[key] = value;
    }
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    return values[key];
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions = IOSOptions.defaultOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
  }) async {
    values.remove(key);
  }
}

void main() {
  test('add/remove/get secret', () async {
    final store = SecureAccountSecretStore.testing(_MockSecureStorage());

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
