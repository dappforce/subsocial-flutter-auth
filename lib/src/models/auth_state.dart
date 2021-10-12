import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';

part 'auth_state.freezed.dart';

/// [AuthState] represents the current state of stored account and the current
/// active account.
@freezed
class AuthState with _$AuthState {
  const AuthState._();

  /// Creates [AuthState]
  const factory AuthState({
    /// The current active account.
    required AuthAccount? activeAccount,

    /// List of the current stored accounts.
    required List<AuthAccount> accounts,
  }) = _AuthState;

  /// Creates an empty state with no active account and no stored accounts
  factory AuthState.empty() => const AuthState(
        activeAccount: null,
        accounts: [],
      );

  /// Returns whether there is a current active account
  bool get isLoggedIn => activeAccount != null;
}
