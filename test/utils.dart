import 'dart:collection';

import 'package:mocktail/mocktail.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:subsocial_flutter_auth/src/auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/sembast_auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/subsocial_auth.dart';
import 'package:subsocial_sdk/generated/def.pb.dart';

import 'mocks.dart';

AuthAccountStore getMemoryAuthStore() {
  return SembastAuthAccountStore(
    getRandomString(20),
    databaseFactory: databaseFactoryMemory,
  );
}

Future<void> removeAllAccounts(SubsocialAuth auth) async {
  final accounts = await auth.getAccounts();
  for (final account in accounts) {
    await auth.removeAccount(account);
  }
}

Future<List<AuthAccount>> importRandomAccountsMocked(
  int n,
  SubsocialAuth auth,
  MockSubsocial mockSdk,
) async {
  final accounts = <AuthAccount>[];
  for (var i = 0; i < n; i++) {
    accounts.add(await importAccountMocked(auth, mockSdk));
  }
  return UnmodifiableListView(accounts);
}

Future<AuthAccount> importAccountMocked(
  SubsocialAuth auth,
  MockSubsocial mockSdk, {
  String? localName,
  String? suri,
  String? password,
  String? publicKey,
}) {
  when(() => mockSdk.importAccount(suri: any(named: 'suri'))).thenAnswer(
    (_) async => ImportedAccount(
      publicKey: publicKey ?? getRandomString(30),
    ),
  );

  return auth.importAccount(
    localName: localName ?? getRandomString(10),
    suri: suri ?? getRandomString(30),
    password: password ?? getRandomString(8),
  );
}

// Future<void> waitForAuthUpdate(SubsocialAuth auth) async {
//   int iterationCounter = 0;
//   while (auth.updateCallCounter != 0) {
//     await Future.delayed(const Duration(milliseconds: 10));
//     iterationCounter++;
//     if (iterationCounter > 200) {
//       throw 'counter is stuck at ${auth.updateCallCounter}';
//     }
//   }
// }
