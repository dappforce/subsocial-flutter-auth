import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:subsocial_flutter_auth/src/account_secret_store.dart';
import 'package:subsocial_flutter_auth/src/auth_account_factory.dart';
import 'package:subsocial_flutter_auth/src/auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/crypto.dart';
import 'package:subsocial_flutter_auth/src/key_derivation_strategy.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/models/auth_state.dart';
import 'package:subsocial_flutter_auth/src/models/crypto_parameters.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';
import 'package:subsocial_flutter_auth/src/secure_account_secret_store.dart';
import 'package:subsocial_flutter_auth/src/sembast_auth_account_store.dart';
import 'package:subsocial_sdk/subsocial_sdk.dart';

/// [SubsocialAuth] manages subsocial accounts.
class SubsocialAuth extends ValueNotifier<AuthState> {
  final Subsocial _sdk;
  final Crypto _crypto;
  final KeyDerivationStrategy _derivationStrategy;
  final AuthAccountStore _accountStore;
  final AccountSecretStore _secretStore;
  final AccountSecretFactory _accountSecretFactory;
  final int _encryptionKeyLength;

  /// Creates [SubsocialAuth].
  SubsocialAuth(
    this._sdk,
    this._crypto,
    this._derivationStrategy,
    this._accountStore,
    this._secretStore,
    this._accountSecretFactory,
    this._encryptionKeyLength,
  ) : super(AuthState.empty());

  /// Creates a [SubsocialAuth] with the default configuration.
  static Future<SubsocialAuth> defaultConfiguration({
    Subsocial? sdk,
    Crypto? crypto,
    KeyDerivationStrategy? derivationStrategy,
    AuthAccountStore? accountStore,
    AccountSecretStore? secretStore,
    AccountSecretFactory? accountSecretFactory,
    int? encryptionKeyLength,
  }) async {
    final _sdk = sdk ?? (await Subsocial.instance);
    final _crypto = crypto ?? Crypto();
    final _derivationStrategy =
        derivationStrategy ?? KeyDerivationStrategy(_crypto);

    final appDir = await getApplicationDocumentsDirectory();
    final _accountStore = accountStore ??
        SembastAuthAccountStore(
          join(appDir.path, 'subsocial_auth_accounts'),
        );

    final _secretStore = secretStore ?? SecureAccountSecretStore();

    final _accountSecretFactory = accountSecretFactory ??
        AccountSecretFactory(
          _crypto,
          _derivationStrategy,
        );

    final _encryptionKeyLength = encryptionKeyLength ?? 32;

    return SubsocialAuth(
      _sdk,
      _crypto,
      _derivationStrategy,
      _accountStore,
      _secretStore,
      _accountSecretFactory,
      _encryptionKeyLength,
    );
  }

  /// Retrieves the current [AuthState]
  AuthState get state => super.value;

  @protected
  set state(AuthState newValue) {
    super.value = newValue;
  }

  @protected
  @override
  set value(AuthState newValue) => super.value = newValue;

  /// Updates the current [AuthState]
  Future<AuthState> update() async {
    return state = AuthState(
      activeAccount: await getActiveAccount(),
      accounts: await getAccounts(),
    );
  }

  /// Generates new mnemonic
  Future<List<String>> generateMnemonic() async {
    final generatedAccount = await _sdk.generateAccount();
    return UnmodifiableListView(generatedAccount.seedPhrase.split(' '));
  }

  /// Import account and adds to the store.
  Future<AuthAccount> importAccount({
    required String localName,
    required String suri,
    required String password,
  }) async {
    final importedAccount = await _sdk.importAccount(suri: suri);

    final publicKey = importedAccount.publicKey;

    final authAccount = AuthAccount(
      localName: localName,
      publicKey: publicKey,
      accountSecretConfig: AccountSecretConfig.defaultConfig(),
    );

    final accountSecret = await _accountSecretFactory.createFromPlainString(
      password: password,
      suri: suri,
    );

    await _accountStore.addAccount(authAccount);
    await _secretStore.addSecret(authAccount.publicKey, accountSecret);

    await update();

    return authAccount;
  }

  /// Returns the current signer id (public key)
  Future<String?> currentSignerId() async {
    final signerId = (await _sdk.currentAccountId()).accountId;
    final isDummySigner =
        signerId == '3qMxrqpKLCvSBz943N5vEERRiyXBZFYySFwnBKXj7vA9W7ng';
    return isDummySigner ? null : signerId;
  }

  /// Loads the current signer into memory, all subsequent transactions will be signed
  /// using this account key.
  /// Returns false if the password is incorrect.
  Future<bool> setSigner(AuthAccount account, String password) async {
    if (!(await verifyPassword(account, password))) {
      return false;
    }

    if (await currentSignerId() == account.publicKey) {
      // no need to set the signer
      return true;
    }

    final suriBytes = await _decryptSuri(account, password);

    // This is how we set the current signer
    final _ = await _sdk.importAccount(
      suri: utf8.decode(suriBytes),
    );
    return true;
  }

  /// Clears the current signer from memory.
  Future<void> unsetSigner() async {
    _sdk.clearSigner();
  }

  /// Verifies if the given [password] is correct for the given [account].
  /// Returns true if password is correct, false otherwise.
  Future<bool> verifyPassword(AuthAccount account, String password) async {
    final secret = (await _secretStore.getSecret(account.publicKey))!;
    return _crypto.verifyHash(VerifyHashParameters(
      plain: Uint8List.fromList(utf8.encode(password)),
      expectedHash: secret.passwordHash,
      salt: secret.passwordSalt,
    ));
  }

  /// Changes the password of an account, given its old password [password] and
  /// the new password [newPassword]. Returns null if the [password] is incorrect
  /// otherwise returns [AuthAccount] instance.
  Future<AuthAccount?> changePassword(
    AuthAccount account,
    String password,
    String newPassword,
  ) async {
    if (!(await verifyPassword(account, password))) {
      return null;
    }

    final suriBytes = await _decryptSuri(account, password);

    final newSecret = await _accountSecretFactory.createFromPlainBytes(
      password: Uint8List.fromList(utf8.encode(newPassword)),
      suri: suriBytes,
    );

    // will override the old secret since they have the same public key.
    await _secretStore.addSecret(account.publicKey, newSecret);

    await update();

    return account;
  }

  /// Change account name to [newName], returning the new [AuthAccount] object.
  Future<AuthAccount> changeName(AuthAccount account, String newName) async {
    final newAccount = account.copyWith(
      localName: newName,
    );

    // will override the old account since they have the same public key.
    await _accountStore.addAccount(newAccount);

    await update();

    return newAccount;
  }

  /// Returns all stored accounts.
  Future<List<AuthAccount>> getAccounts() async {
    return UnmodifiableListView(await _accountStore.getStoredAccounts());
  }

  /// Removes [AuthAccount], active account will be cleared if it's the same account.
  Future<void> removeAccount(AuthAccount account) async {
    if (state.activeAccount?.publicKey == account.publicKey) {
      await unsetActiveAccount();
    }
    await _accountStore.removeAccount(account.publicKey);

    await update();
  }

  /// Returns the current active account, returns null if there is no active account.
  Future<AuthAccount?> getActiveAccount() async {
    return _accountStore.getActiveAccount();
  }

  /// Sets the current active account.
  Future<bool> setActiveAccount(AuthAccount account) async {
    final res = await _accountStore.setActiveAccount(account);

    await update();

    return res;
  }

  /// Clears the current active account.
  Future<bool> unsetActiveAccount() async {
    final res = await _accountStore.unsetActiveAccount();

    await update();

    return res;
  }

  Future<Uint8List> _decryptSuri(AuthAccount account, String password) async {
    final secret = (await _secretStore.getSecret(account.publicKey))!;

    final passwordBytes = Uint8List.fromList(utf8.encode(password));
    final key = await _derivationStrategy.driveKey(
      _encryptionKeyLength,
      passwordBytes,
      secret.encryptionKeySalt,
    );
    return _crypto.decrypt(DecryptParameters(
      key: key,
      cipher: secret.encryptedSuri,
    ));
  }
}
