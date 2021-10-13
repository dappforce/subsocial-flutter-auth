import 'models/auth_account.dart';

/// Provides a storage for [AuthAccount].
abstract class AuthAccountStore {
  /// Returns a list of all stored accounts
  Future<List<AuthAccount>> getStoredAccounts();

  /// Returns the current account
  Future<AuthAccount?> getCurrentAccount();

  /// Clears the current active account
  Future<bool> unsetCurrentAccount();

  /// Sets the current account account
  Future<bool> setCurrentAccount(AuthAccount account);

  /// Retrieves an account by its public key.
  Future<AuthAccount?> getAccount(String publicKey);

  /// Adds new account, if the account already exists it will be overridden.
  Future<void> addAccount(AuthAccount account);

  /// Removes the account with the public key [publicKey]
  Future<void> removeAccount(String publicKey);
}
