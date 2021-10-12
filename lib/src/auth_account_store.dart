import 'package:flutter/cupertino.dart';

import 'models/auth_account.dart';

abstract class AuthAccountStore implements ChangeNotifier {
  /// Returns a list of all stored accounts
  Future<List<AuthAccount>> getStoredAccounts();

  /// Returns the active account
  Future<AuthAccount?> getActiveAccount();

  /// Clears the current active account
  Future<bool> unsetActiveAccount();

  /// Sets the current account account
  Future<bool> setActiveAccount(AuthAccount account);

  /// Retrieves an account by its public key.
  Future<AuthAccount?> getAccount(String publicKey);

  /// Adds new account, if the account already exists it will be overridden.
  Future<void> addAccount(AuthAccount account);

  /// Removes the account with the public key [publicKey]
  Future<void> removeAccount(String publicKey);
}
