import 'package:mocktail/mocktail.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/subsocial_auth.dart';
import 'package:subsocial_sdk/generated/def.pb.dart';

import 'mocks.dart';

Future<AuthAccount> importAccountMocked(
  SubsocialAuth auth,
  MockSubsocial mockSdk,
  String localName,
  String suri,
  String password,
) {
  when(() => mockSdk.importAccount(suri: any(named: 'suri'))).thenAnswer(
    (_) async => ImportedAccount(
      publicKey: getRandomString(30),
    ),
  );

  return auth.importAccount(
      localName: localName, suri: suri, password: password);
}

Future<void> waitForAuthUpdate(SubsocialAuth auth) async {
  int iterationCounter = 0;
  while (auth.updateCallCounter != 0) {
    await Future.delayed(const Duration(milliseconds: 10));
    iterationCounter++;
    if (iterationCounter > 200) {
      throw 'counter is stuck at ${auth.updateCallCounter}';
    }
  }
}
