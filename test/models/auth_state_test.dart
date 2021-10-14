import 'package:flutter_test/flutter_test.dart';
import 'package:subsocial_auth/src/models/auth_state.dart';

import '../mocks.dart';

void main() {
  test('==/hashCode', () {
    final currentAccount = generateRandomMockAccount();
    final accounts = List.generate(10, (index) => generateRandomMockAccount());

    final obj1 = AuthState(
      currentAccount: currentAccount,
      accounts: accounts,
    );

    final obj2 = AuthState(
      currentAccount: currentAccount,
      accounts: accounts,
    );

    expect(obj1 == obj2 && obj2 == obj1, isTrue);
    expect(obj1.hashCode == obj2.hashCode, isTrue);

    final obj3 = AuthState(
      currentAccount: null,
      accounts: accounts,
    );

    final obj4 = AuthState(
      currentAccount: null,
      accounts: accounts,
    );

    expect(obj3 == obj4 && obj4 == obj3, isTrue);
    expect(obj3.hashCode == obj4.hashCode, isTrue);

    expect(obj1 == obj4 || obj4 == obj1, isFalse);
    expect(obj1.hashCode == obj4.hashCode, isFalse);
  });
}
