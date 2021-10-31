import 'package:subsocial_auth/src/models/account_secret.dart';

/// Provides a storage for [AccountSecret].
abstract class AccountSecretStore {
  /// Retrieves an [AccountSecret] by its [publicKey]
  Future<AccountSecret?> getSecret(String publicKey);

  /// Stores [AccountSecret] with [publicKey] as its key.
  Future<void> addSecret(String publicKey, AccountSecret secret);

  /// Removes the [AccountSecret] with [publicKey] as key.
  Future<void> removeSecret(String publicKey);
}
