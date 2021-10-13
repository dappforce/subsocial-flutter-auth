import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';

/// [AuthState] represents the current state of stored account and the current account.
@immutable
class AuthState {
  /// The current active account.
  final AuthAccount? currentAccount;

  /// List of the current stored accounts.
  final List<AuthAccount> accounts;

  /// Creates [AuthState]
  const AuthState({
    required this.currentAccount,
    required this.accounts,
  });

  /// Creates an empty state with no current account and no stored accounts
  factory AuthState.empty() => const AuthState(
        currentAccount: null,
        accounts: [],
      );

  /// Returns whether there is a current active account
  bool get isLoggedIn => currentAccount != null;

  List<Object?> get _props => [currentAccount, accounts];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}
