import 'dart:async';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/auth_account.dart';

const String _keyPrefix = 'subsocial:accounts';

/// [AuthAccountStore] stores accounts and the current active account on disk.
class AuthAccountStore extends ChangeNotifier {
  final Box<AuthAccount> _authAccountBox;
  final SharedPreferences _sharedPreferences;

  /// Creates [AuthAccountStore]. Make sure to initialize hive before calling.
  AuthAccountStore(this._authAccountBox, this._sharedPreferences) {
    Hive.registerAdapter(AuthAccountAdapter(), override: true);
    Hive.registerAdapter(AccountSecretAdapter(), override: true);
  }

  /// Returns a list of all stored accounts
  Future<IList<AuthAccount>> getStoredAccounts() async {
    return _authAccountBox.values.toIList();
  }

  /// Returns the active account
  Future<AuthAccount?> getActiveAccount() async {
    final String? activeAccountPublicKey =
        _sharedPreferences.getString('$_keyPrefix:active_id');
    if (activeAccountPublicKey == null) return null;
    return getAccount(activeAccountPublicKey);
  }

  /// Clears the current active account
  Future<bool> unsetActiveAccount() async {
    final result = await _sharedPreferences.remove('$_keyPrefix:active_id');
    if (result) {
      notifyListeners();
    }
    return result;
  }

  /// Sets the current account account
  Future<bool> setActiveAccount(AuthAccount account) async {
    final result = await _sharedPreferences.setString(
      '$_keyPrefix:active_id',
      account.publicKey,
    );
    if (result) {
      notifyListeners();
    }
    return result;
  }

  /// Retrieves an account by its public key.
  Future<AuthAccount?> getAccount(String publicKey) async {
    return _authAccountBox.get(publicKey);
  }

  /// Adds new account, if the account already exists it will be overridden.
  Future<void> addAccount(AuthAccount account) async {
    await _authAccountBox.put(account.publicKey, account);
    notifyListeners();
  }

  /// Removes the account with the public key [publicKey]
  Future<void> removeAccount(String publicKey) async {
    await _authAccountBox.delete(publicKey);
    notifyListeners();
  }
}
