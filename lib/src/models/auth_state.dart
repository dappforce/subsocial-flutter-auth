import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';

/// [AuthState] represents the current state of stored account and the current
/// active account.
@immutable
class AuthState {
  /// The current active account.
  final AuthAccount? activeAccount;

  /// List of the current stored accounts.
  final List<AuthAccount> accounts;

  /// Creates [AuthState]
  const AuthState({
    required this.activeAccount,
    required this.accounts,
  });

  /// Creates an empty state with no active account and no stored accounts
  factory AuthState.empty() => const AuthState(
        activeAccount: null,
        accounts: [],
      );

  /// Returns whether there is a current active account
  bool get isLoggedIn => activeAccount != null;

  List<Object?> get _props => [activeAccount, accounts];

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
