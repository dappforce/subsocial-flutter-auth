import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsocial_flutter_auth/src/subsocial_auth.dart';
import 'package:subsocial_sdk/generated/def.pb.dart';

import 'mocks.dart';

void main() {
  final mockSdk = MockSubsocial();
  setUp(() {
    Hive.init('./test_data/hive');
    reset(mockSdk);
    SharedPreferences.setMockInitialValues({});
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
}
