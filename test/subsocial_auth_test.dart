import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/models/auth_state.dart';
import 'package:subsocial_flutter_auth/src/subsocial_auth.dart';
import 'package:subsocial_sdk/generated/def.pb.dart';

import 'mocks.dart';
import 'utils.dart';

void main() {
  final mockSdk = MockSubsocial();
  setUpAll(() {
    disableSembastCooperator();
    registerFallbackValue(Uint8List(0));
  });
  setUp(() {
    final pathProviderMock = MockPathProviderPlatform.setUp();
    when(() => pathProviderMock.getApplicationDocumentsPath())
        .thenAnswer((_) async => './test_data');

    reset(mockSdk);
    SharedPreferences.setMockInitialValues({});
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
    var account = generateRandomMockAccount(
      passwordSalt: salt,
      passwordHash: hash,
    );
    final mockCrypto = MockCrypto();

    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
      crypto: mockCrypto,
    );

    when(() => mockCrypto.verifyHash(
          plain: any(named: 'plain'),
          expectedHash: any(named: 'expectedHash'),
          salt: any(named: 'salt'),
        )).thenAnswer((invocation) async => false);

    when(() => mockCrypto.verifyHash(
          plain: Uint8List.fromList(utf8.encode(correctPassword)),
          expectedHash: any(named: 'expectedHash'),
          salt: any(named: 'salt'),
        )).thenAnswer((invocation) async => true);

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
    final account =
        await importAccountMocked(auth, mockSdk, name, suri, password);

    expect(await auth.verifyPassword(account, '1212121212'), false);
    expect(await auth.verifyPassword(account, password), true);
  });
  test('changePassword', () async {
    final auth = await SubsocialAuth.defaultConfiguration(sdk: mockSdk);
    const suri = '12121212';
    const name = 'tarek';
    const password = '1231';
    final account =
        await importAccountMocked(auth, mockSdk, name, suri, password);

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
  });
  test('change in data will notify listeners', () async {
    final auth = await SubsocialAuth.defaultConfiguration(
      sdk: mockSdk,
    );

    int invokedCounter = 0;
    List<AuthState> states = [];
    void _listener(AuthState s) {
      invokedCounter++;
      states.add(s);
    }

    final removeListener = auth.addListener(
      _listener,
      fireImmediately: false,
    );
    final List<AuthAccount> accounts = [];

    for (var i = 0; i < 3; i++) {
      accounts.add(
        await importAccountMocked(
          auth,
          mockSdk,
          getRandomString(10), // name
          getRandomString(30), // suri
          getRandomString(8), // password
        ),
      );
    }

    await waitForAuthUpdate(auth);
    expect(invokedCounter, 3);

    await auth.setActiveAccount(accounts[0]);
    await auth.unsetActiveAccount();

    await waitForAuthUpdate(auth);
    expect(invokedCounter, 5);

    final currentAccounts = await auth.getAccounts();
    await Future.wait(currentAccounts.map((account) async {
      await auth.removeAccount(account);
    }));
    await waitForAuthUpdate(auth);
    expect(invokedCounter, 8);

    removeListener();
  });
//
//   test('add/remove/get account', () async {
//     final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
//     final accounts =
//         List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
//     await Future.wait(accounts.map((account) async {
//       await store.addAccount(account);
//     }));
//
//     final resultAccountsAfterAdd = await store.getStoredAccounts();
//     expect(resultAccountsAfterAdd.toSet(), accounts.toSet()); // ignore order
//
//     await Future.wait(accounts.map((account) async {
//       await store.removeAccount(account.publicKey);
//     }));
//
//     final resultAccountsAfterRemove = await store.getStoredAccounts();
//
//     expect(resultAccountsAfterRemove, isEmpty);
//
//     await store.addAccount(generateRandomMockAccount());
//     final afterAnotherAdd = await store.getStoredAccounts();
//     expect(afterAnotherAdd.length, 1);
//   });
//
//   test('add will override account if same public key', () async {
//     final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
//     final a = await store.getStoredAccounts();
//
//     final account1 = generateRandomMockAccount();
//     final account2 = generateRandomMockAccount().copyWith(
//       publicKey: account1.publicKey,
//     );
//
//     await store.addAccount(account1);
//
//     expect(await store.getStoredAccounts(), [account1].lock);
//
//     await store.addAccount(account2);
//
//     expect(await store.getStoredAccounts(), [account2].lock);
//   });
//
//   test('get account', () async {
//     final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
//     final accounts =
//         List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
//     await Future.wait(accounts.map((account) async {
//       await store.addAccount(account);
//     }));
//
//     final result = await store.getAccount(accounts[5].publicKey);
//
//     expect(result, accounts[5]);
//   });
//
//   test('active account', () async {
//     final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
//     final accounts =
//         List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
//     await Future.wait(accounts.map((account) async {
//       await store.addAccount(account);
//     }));
//
//     expect(await store.getActiveAccount(), isNull);
//
//     await store.setActiveAccount(accounts[1]);
//
//     expect(await store.getActiveAccount(), accounts[1]);
//
//     await store.unsetActiveAccount();
//
//     expect(await store.getActiveAccount(), isNull);
//
//     await store.setActiveAccount(accounts[4]);
//
//     expect(await store.getActiveAccount(), accounts[4]);
//
//     // no change to accounts
//     expect((await store.getStoredAccounts()).toSet(), accounts.toSet());
//   });
}
