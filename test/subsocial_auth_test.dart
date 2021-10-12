import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:encrypt/encrypt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/models/auth_state.dart';
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_flutter_auth/src/subsocial_auth.dart';
import 'package:subsocial_sdk/generated/def.pb.dart';

import 'mocks.dart';
import 'utils.dart';

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
    expect(auth.state.activeAccount, isNull);
  });
  test('generate mnemonic', () async {
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);
    final IList<String> expectedWords = [
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
    ].lock;

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
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);

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
        List<AuthAccount>.generate(10, (index) => generateRandomMockAccount())
            .lock;
    final activeAccount = accounts[Random().nextInt(accounts.length)];
    when(() => mockStore.getStoredAccounts()).thenAnswer((_) async => accounts);
    when(() => mockStore.getActiveAccount()).thenAnswer((_) async => null);

    expect(auth.state.isLoggedIn, false);
    expect(auth.state.accounts.isEmpty, true);
    expect(auth.state.activeAccount, isNull);

    await auth.update();

    expect(auth.state.isLoggedIn, false);
    expect(auth.state.accounts, accounts);
    expect(auth.state.activeAccount, isNull);

    when(() => mockStore.getActiveAccount())
        .thenAnswer((_) async => activeAccount);

    await auth.update();

    expect(auth.state.isLoggedIn, true);
    expect(auth.state.accounts, accounts);
    expect(auth.state.activeAccount, activeAccount);
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
    final salt = SecureRandom(12).bytes;
    final hash = SecureRandom(12).bytes;
    final account = generateRandomMockAccount(
      passwordSalt: salt,
      passwordHash: hash,
    );
    final mockCrypto = MockCrypto();

    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      crypto: mockCrypto,
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
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);
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
    expect(
      changePasswordAcc2,
      isNot(equals(account)),
      reason: 'changing password will change account secret',
    );

    expect(await auth.verifyPassword(changePasswordAcc2!, '124fdsa'), false);
    expect(await auth.verifyPassword(changePasswordAcc2, password), false);
    expect(await auth.verifyPassword(changePasswordAcc2, newPassword), true);

    expect(await auth.getAccounts(), [changePasswordAcc2]);
  });
  test('change in data will notify listeners', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
    );

    int invokedCounter = 0;
    void _listener(AuthState s) {
      invokedCounter++;
    }

    final removeListener = auth.addListener(
      _listener,
      fireImmediately: false,
    );

    final accounts = await importRandomAccountsMocked(3, auth, mockSdk);

    await waitForAuthUpdate(auth);
    expect(invokedCounter, 3);

    await auth.setActiveAccount(accounts[0]);
    await auth.unsetActiveAccount();

    await waitForAuthUpdate(auth);
    expect(invokedCounter, 5);

    await removeAllAccounts(auth);
    await waitForAuthUpdate(auth);
    expect(invokedCounter, 8);

    removeListener();
  });

  test('add/remove/get account', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
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
    );

    final account1 = await importAccountMocked(auth, mockSdk);

    expect(await auth.getAccounts(), [account1].lock);

    final account2 = await importAccountMocked(
      auth,
      mockSdk,
      publicKey: account1.publicKey,
    );

    expect(account1, isNot(equals(account2)));

    expect(await auth.getAccounts(), [account2].lock);
  });

  test('active account', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
    );
    final accounts = await importRandomAccountsMocked(3, auth, mockSdk);

    expect(await auth.getActiveAccount(), isNull);

    await auth.setActiveAccount(accounts[1]);

    expect(await auth.getActiveAccount(), accounts[1]);

    await auth.unsetActiveAccount();

    expect(await auth.getActiveAccount(), isNull);

    await auth.setActiveAccount(accounts[0]);

    expect(await auth.getActiveAccount(), accounts[0]);

    // no change to accounts
    expect((await auth.getAccounts()).toSet(), accounts.toSet());

    await auth.removeAccount(accounts[0]);
    expect(
      await auth.getActiveAccount(),
      isNull,
      reason: 'removing active account will unset it',
    );
  });

  test('set/unset signer', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      accountStore: getMemoryAuthStore(),
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
