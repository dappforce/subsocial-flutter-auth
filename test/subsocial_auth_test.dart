import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:subsocial_auth/src/account_secret_store.dart';
import 'package:subsocial_auth/src/models/auth_account.dart';
import 'package:subsocial_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_auth/src/secure_account_secret_store.dart';
import 'package:subsocial_auth/src/subsocial_auth.dart';
import 'package:subsocial_sdk/generated/def.pb.dart';

import 'mocks.dart';
import 'utils.dart';

AccountSecretStore getTestAccountSecretStore() {
  return SecureAccountSecretStore.testing(MockSecureStorage());
}

void main() {
  final mockSdk = MockSubsocial();
  setUpAll(() {
    disableSembastCooperator();
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(FakeVerifyHashParameters());
  });
  setUp(() {
    final pathProviderMock = MockPathProviderPlatform.setUp();
    when(() => pathProviderMock.getApplicationDocumentsPath())
        .thenAnswer((_) async => './test_data');

    reset(mockSdk);
  });
  tearDown(() async {
    final dbFile = File('./test_data/subsocial_auth_accounts');
    if (await dbFile.exists()) {
      await dbFile.delete();
    }
  });
  test('initial state is empty', () async {
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);
    expect(auth.state.isLoggedIn, false);
    expect(auth.state.accounts.isEmpty, true);
    expect(auth.state.currentAccount, isNull);
  });
  test('generate mnemonic', () async {
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);
    final List<String> expectedWords = [
      'sock',
      'obey',
      'cash',
      'present',
      'wall',
      'human',
      'someone',
      'theory',
      'grape',
      'rich',
      'absorb',
      'embrace',
      'athlete',
      'juice',
      'dish',
    ];

    when(() => mockSdk.generateAccount()).thenAnswer(
      (_) async => GeneratedAccount(
        publicKey: '',
        seedPhrase: expectedWords.join(' '),
      ),
    );

    final words = await auth.generateMnemonic();
    expect(words, expectedWords);
  });
  test('import account new account', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      secretStore: getTestAccountSecretStore(),
    );

    const localName = 'Tarek';
    const suri =
        'sock obey cash present wall human someone theory grape rich absorb embrace athlete juice dish';
    const password = 'PazzWord';

    const expectedPublicKey = '1234121212';

    when(() => mockSdk.importAccount(suri: any(named: 'suri'))).thenAnswer(
      (_) async => ImportedAccount(
        publicKey: expectedPublicKey,
      ),
    );

    final importedAccount = await auth.importAccount(
      localName: localName,
      suri: suri,
      password: password,
    );

    expect(importedAccount.publicKey, expectedPublicKey);
    expect(importedAccount.localName, localName);

    final accounts = await auth.getAccounts();

    expect(importedAccount, isIn(accounts));
  });
  test('update will fetch data from store', () async {
    final mockStore = MockAuthAccountStore();
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: mockStore,
    );
    final accounts =
        List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
    final activeAccount = accounts[Random().nextInt(accounts.length)];
    when(() => mockStore.getStoredAccounts()).thenAnswer((_) async => accounts);
    when(() => mockStore.getCurrentAccount()).thenAnswer((_) async => null);

    expect(auth.state.isLoggedIn, false);
    expect(auth.state.accounts.isEmpty, true);
    expect(auth.state.currentAccount, isNull);

    await auth.update();

    expect(auth.state.isLoggedIn, false);
    expect(auth.state.accounts, accounts);
    expect(auth.state.currentAccount, isNull);

    when(() => mockStore.getCurrentAccount())
        .thenAnswer((_) async => activeAccount);

    await auth.update();

    expect(auth.state.isLoggedIn, true);
    expect(auth.state.accounts, accounts);
    expect(auth.state.currentAccount, activeAccount);
  });
  test('currentSignerId', () async {
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);

    const expectedAccountId = '1241324fsafdsf';

    when(() => mockSdk.currentAccountId())
        .thenAnswer((invocation) async => CurrentAccountId(
              accountId: expectedAccountId,
            ));

    final currentSignerId = await auth.currentSignerId();

    expect(currentSignerId, expectedAccountId);
  });
  test('verifyPassword stubbed', () async {
    const correctPassword = '123';
    const incorrectPassword = '3323';
    final account = generateRandomMockAccount();
    final secret = genRandomAccountSecret();
    final mockCrypto = MockCrypto();

    final secretStore = getTestAccountSecretStore();
    await secretStore.addSecret(account.publicKey, secret);

    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      crypto: mockCrypto,
      secretStore: secretStore,
    );

    when(() => mockCrypto.verifyHash(any()))
        .thenAnswer((invocation) async => false);

    when(() => mockCrypto.verifyHash(any(that: predicate<VerifyHashParameters>(
          (params) {
            return const DeepCollectionEquality().equals(
              params.plain,
              Uint8List.fromList(utf8.encode(correctPassword)),
            );
          },
        )))).thenAnswer((invocation) async => true);

    final resultShouldBeFalse =
        await auth.verifyPassword(account, incorrectPassword);

    expect(resultShouldBeFalse, false);

    final resultShouldBeTrue =
        await auth.verifyPassword(account, correctPassword);

    expect(resultShouldBeTrue, true);
  });
  test('verifyPassword', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      secretStore: getTestAccountSecretStore(),
    );
    const suri = '12121212';
    const name = 'tarek';
    const password = '1231';
    final account = await importAccountMocked(
      auth,
      mockSdk,
      localName: name,
      suri: suri,
      password: password,
    );

    expect(await auth.verifyPassword(account, '1212121212'), false);
    expect(await auth.verifyPassword(account, password), true);
  });
  test('changePassword', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
      secretStore: getTestAccountSecretStore(),
    );
    const suri = '12121212';
    const name = 'tarek';
    const password = '1231';
    final account = await importAccountMocked(
      auth,
      mockSdk,
      localName: name,
      suri: suri,
      password: password,
    );

    expect(await auth.getAccounts(), [account]);

    expect(await auth.verifyPassword(account, '1212121212'), false);
    expect(await auth.verifyPassword(account, password), true);

    const newPassword = '1sdks';
    final changePasswordAcc1 =
        await auth.changePassword(account, 'incorrect password', newPassword);
    expect(changePasswordAcc1, isNull);
    final changePasswordAcc2 =
        await auth.changePassword(account, password, newPassword);
    expect(changePasswordAcc2, isNotNull);

    expect(await auth.verifyPassword(changePasswordAcc2!, '124fdsa'), false);
    expect(await auth.verifyPassword(changePasswordAcc2, password), false);
    expect(await auth.verifyPassword(changePasswordAcc2, newPassword), true);

    expect(await auth.getAccounts(), [changePasswordAcc2]);
  });
  test('change in data will notify listeners', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
      secretStore: getTestAccountSecretStore(),
    );

    int invokedCounter = 0;
    void _listener() {
      invokedCounter++;
    }

    auth.addListener(_listener);

    final accounts = await importRandomAccountsMocked(3, auth, mockSdk);

    expect(invokedCounter, 3);

    await auth.setCurrentAccount(accounts[0]);
    expect(invokedCounter, 4);

    await auth.unsetCurrentAccount();
    expect(invokedCounter, 5);

    await removeAllAccounts(auth);
    expect(invokedCounter, 8);

    auth.removeListener(_listener);
  });

  test('add/remove/get account', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
      secretStore: getTestAccountSecretStore(),
    );

    final accounts = await importRandomAccountsMocked(3, auth, mockSdk);

    final resultAccountsAfterAdd = await auth.getAccounts();
    expect(resultAccountsAfterAdd.toSet(), accounts.toSet()); // ignore order

    await removeAllAccounts(auth);

    final resultAccountsAfterRemove = await auth.getAccounts();

    expect(resultAccountsAfterRemove, isEmpty);

    await importRandomAccountsMocked(2, auth, mockSdk);
    final afterAnotherAdd = await auth.getAccounts();
    expect(afterAnotherAdd.length, 2);
  });

  test('add will override account if same public key', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
      secretStore: getTestAccountSecretStore(),
    );

    final account1 = await importAccountMocked(auth, mockSdk);

    expect(await auth.getAccounts(), [account1]);

    final account2 = await importAccountMocked(
      auth,
      mockSdk,
      publicKey: account1.publicKey,
    );

    expect(account1, isNot(equals(account2)));

    expect(await auth.getAccounts(), [account2]);
  });

  test('active account', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
      secretStore: getTestAccountSecretStore(),
    );
    final accounts = await importRandomAccountsMocked(3, auth, mockSdk);

    expect(await auth.getCurrentAccount(), isNull);

    await auth.setCurrentAccount(accounts[1]);

    expect(await auth.getCurrentAccount(), accounts[1]);

    await auth.unsetCurrentAccount();

    expect(await auth.getCurrentAccount(), isNull);

    await auth.setCurrentAccount(accounts[0]);

    expect(await auth.getCurrentAccount(), accounts[0]);

    // no change to accounts
    expect((await auth.getAccounts()).toSet(), accounts.toSet());

    await auth.removeAccount(accounts[0]);
    expect(
      await auth.getCurrentAccount(),
      isNull,
      reason: 'removing active account will unset it',
    );
  });

  test('set/unset signer', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
      secretStore: getTestAccountSecretStore(),
    );

    when(() => mockSdk.currentAccountId())
        .thenAnswer((invocation) async => CurrentAccountId(
              accountId: getRandomString(30),
            ));

    when(() => mockSdk.clearSigner()).thenAnswer((invocation) async {});

    await auth.currentSignerId();
    verify(() => mockSdk.currentAccountId()).called(1);

    final accounts = await importRandomAccountsMocked(3, auth, mockSdk);
    verify(() => mockSdk.importAccount(suri: any(named: 'suri'))).called(3);

    const accPass = '12412';
    const accSuri = 'this is suri lol';
    final acc = await importAccountMocked(
      auth,
      mockSdk,
      password: accPass,
      suri: accSuri,
    );
    verify(
      () => mockSdk.importAccount(suri: accSuri),
    ).called(1);

    final resWrongPassword = await auth.setSigner(acc, 'wrong password');
    expect(resWrongPassword, false);

    verifyNever(() => mockSdk.importAccount(suri: any(named: 'suri')));

    final resCorrectPassword = await auth.setSigner(acc, accPass);
    expect(resCorrectPassword, true);
    verify(
      () => mockSdk.importAccount(suri: accSuri),
    ).called(1);

    await auth.unsetSigner();
    verify(() => mockSdk.clearSigner()).called(1);
  });
}
