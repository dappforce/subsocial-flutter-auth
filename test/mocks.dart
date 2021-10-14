import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:subsocial_auth/src/auth_account_store.dart';
import 'package:subsocial_auth/src/crypto.dart';
import 'package:subsocial_auth/src/models/account_secret.dart';
import 'package:subsocial_auth/src/models/auth_account.dart';
import 'package:subsocial_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_auth/src/models/secret_config.dart';
import 'package:subsocial_sdk/subsocial_sdk.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

AccountSecret genRandomAccountSecret({
  Uint8List? passwordSalt,
  Uint8List? passwordHash,
}) {
  return AccountSecret(
    encryptedSuri: SecureRandom(16).bytes,
    encryptionKeySalt: SecureRandom(16).bytes,
    passwordHash: passwordHash ?? SecureRandom(16).bytes,
    passwordSalt: passwordSalt ?? SecureRandom(16).bytes,
  );
}

AuthAccount generateRandomMockAccount() {
  return AuthAccount(
    localName: getRandomString(10),
    publicKey: getRandomString(30),
    accountSecretConfig: AccountSecretConfig.defaultConfig(),
  );
}

class MockSubsocial extends Mock implements Subsocial {}

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  static MockPathProviderPlatform setUp() {
    final mock = MockPathProviderPlatform();
    PathProviderPlatform.instance = mock;
    return mock;
  }
}

class MockAuthAccountStore extends Mock implements AuthAccountStore {}

class MockCrypto extends Mock implements Crypto {}

class FakeVerifyHashParameters extends Fake implements VerifyHashParameters {}

class FakeAccountSecretConfig extends Fake implements AccountSecretConfig {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {
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
