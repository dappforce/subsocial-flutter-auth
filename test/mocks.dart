import 'dart:math';
import 'dart:typed_data';

import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:subsocial_flutter_auth/src/auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/crypto.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_sdk/subsocial_sdk.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

AuthAccount generateRandomMockAccount({
  Uint8List? passwordSalt,
  Uint8List? passwordHash,
}) {
  return AuthAccount(
    localName: getRandomString(10),
    publicKey: getRandomString(30),
    accountSecret: AccountSecret(
      encryptedSuri: Uint8List(0),
      encryptionKeySalt: Uint8List(0),
      passwordHash: passwordHash ?? Uint8List(0),
      passwordSalt: passwordSalt ?? Uint8List(0),
    ),
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
