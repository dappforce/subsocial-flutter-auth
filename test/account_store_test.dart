import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:subsocial_flutter_auth/src/auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/sembast_auth_account_store.dart';

import 'mocks.dart';

const _databasesDirPath = './test_data/account_store_test/';

// Creates a random db for each test case
String _dbPath() {
  return join(_databasesDirPath, getRandomString(20));
}

void main() {
  tearDownAll(() async {
    final dbsDir = Directory(_databasesDirPath);
    if (await dbsDir.exists()) {
      await dbsDir.delete(recursive: true);
    }
  });

  // test('change in data will notify listeners', () async {
  //   final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
  //   int invokedCounter = 0;
  //   void _listener() => invokedCounter++;
  //   store.addListener(_listener);
  //   final accounts =
  //       List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
  //
  //   await Future.wait(accounts.map((account) async {
  //     await store.addAccount(account);
  //   }));
  //   expect(invokedCounter, 10);
  //
  //   await store.setActiveAccount(generateRandomMockAccount());
  //   await store.unsetActiveAccount();
  //
  //   expect(invokedCounter, 12);
  //
  //   await Future.wait(accounts.map((account) async {
  //     await store.removeAccount(account.publicKey);
  //   }));
  //   expect(invokedCounter, 22);
  //
  //   store.removeListener(_listener);
  // });

  test('add/remove/get account', () async {
    final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
    final accounts =
        List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
    await Future.wait(accounts.map((account) async {
      await store.addAccount(account);
    }));

    final resultAccountsAfterAdd = await store.getStoredAccounts();
    expect(resultAccountsAfterAdd.toSet(), accounts.toSet()); // ignore order

    await Future.wait(accounts.map((account) async {
      await store.removeAccount(account.publicKey);
    }));

    final resultAccountsAfterRemove = await store.getStoredAccounts();

    expect(resultAccountsAfterRemove, isEmpty);

    await store.addAccount(generateRandomMockAccount());
    final afterAnotherAdd = await store.getStoredAccounts();
    expect(afterAnotherAdd.length, 1);
  });

  test('add will override account if same public key', () async {
    final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
    final a = await store.getStoredAccounts();

    final account1 = generateRandomMockAccount();
    final account2 = generateRandomMockAccount().copyWith(
      publicKey: account1.publicKey,
    );

    await store.addAccount(account1);

    expect(await store.getStoredAccounts(), [account1]);

    await store.addAccount(account2);

    expect(await store.getStoredAccounts(), [account2]);
  });

  test('get account', () async {
    final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
    final accounts =
        List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
    await Future.wait(accounts.map((account) async {
      await store.addAccount(account);
    }));

    final result = await store.getAccount(accounts[5].publicKey);

    expect(result, accounts[5]);
  });

  test('active account', () async {
    final AuthAccountStore store = SembastAuthAccountStore(_dbPath());
    final accounts =
        List<AuthAccount>.generate(10, (index) => generateRandomMockAccount());
    await Future.wait(accounts.map((account) async {
      await store.addAccount(account);
    }));

    expect(await store.getCurrentAccount(), isNull);

    await store.setCurrentAccount(accounts[1]);

    expect(await store.getCurrentAccount(), accounts[1]);

    await store.unsetCurrentAccount();

    expect(await store.getCurrentAccount(), isNull);

    await store.setCurrentAccount(accounts[4]);

    expect(await store.getCurrentAccount(), accounts[4]);

    // no change to accounts
    expect((await store.getStoredAccounts()).toSet(), accounts.toSet());
  });
}
