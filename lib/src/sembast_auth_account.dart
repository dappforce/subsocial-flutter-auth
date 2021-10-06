import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:sembast/blob.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:subsocial_flutter_auth/src/auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';

/// [SembastAuthAccountStore] stores accounts and the current active account on disk
/// using sembast package.
class SembastAuthAccountStore extends ChangeNotifier
    implements AuthAccountStore {
  late Completer<Database> _databaseCompleter;
  final _accountsStore = StoreRef<String, Map<String, Object?>>('accounts');
  final _activeAccountStore = StoreRef<int, String>('active_account');

  /// Creates [SembastAuthAccountStore].
  SembastAuthAccountStore(String databasePath) {
    _databaseCompleter = Completer()..complete(_openDatabase(databasePath));
  }

  static Future<Database> _openDatabase(String dbPath) async {
    final DatabaseFactory dbFactory = databaseFactoryIo;
    final Database db = await dbFactory.openDatabase(dbPath);
    return db;
  }

  Future<Database> get _db => _databaseCompleter.future;

  @override
  Future<void> addAccount(AuthAccount account) async {
    final mapped = account.toSembastMap();
    await _accountsStore.record(mapped.key).put(await _db, mapped.value);
    notifyListeners();
  }

  @override
  Future<AuthAccount?> getAccount(String publicKey) async {
    final raw = await _accountsStore.record(publicKey).get(await _db);
    return SembastAuthAccountMapper.fromNullableSembastMap(raw);
  }

  @override
  Future<AuthAccount?> getActiveAccount() async {
    final publicKey = await _activeAccountStore.record(0).get(await _db);
    if (publicKey == null) return null;
    return getAccount(publicKey);
  }

  @override
  Future<IList<AuthAccount>> getStoredAccounts() async {
    return (await _accountsStore.find(await _db))
        .map(
          (snapshot) =>
              SembastAuthAccountMapper.fromNullableSembastMap(snapshot.value),
        )
        .whereNotNull()
        .toList()
        .lock;
  }

  @override
  Future<void> removeAccount(String publicKey) async {
    await _accountsStore.record(publicKey).delete(await _db);
    notifyListeners();
  }

  @override
  Future<bool> setActiveAccount(AuthAccount account) async {
    await _activeAccountStore.record(0).put(await _db, account.publicKey);
    notifyListeners();
    return true;
  }

  @override
  Future<bool> unsetActiveAccount() async {
    await _activeAccountStore.record(0).delete(await _db);
    notifyListeners();
    return true;
  }
}

/// Maps [AuthAccount] for sembast storage.
extension SembastAuthAccountMapper on AuthAccount {
  MapEntry<String, Map<String, Object>> toSembastMap() {
    final secret = accountSecret;
    return MapEntry(
      publicKey,
      {
        'name': localName,
        'publicKey': publicKey,
        'encryptedSuri': Blob(secret.encryptedSuri),
        'encryptionKeySalt': Blob(secret.encryptionKeySalt),
        'passwordHash': Blob(secret.passwordHash),
        'passwordSalt': Blob(secret.passwordSalt),
      },
    );
  }

  static AuthAccount? fromNullableSembastMap(Map<String, Object?>? map) {
    if (map == null) return null;
    return fromSembastMap(map);
  }

  static AuthAccount fromSembastMap(Map<String, Object?> map) {
    return AuthAccount(
      localName: map['name']! as String,
      publicKey: map['publicKey']! as String,
      accountSecret: AccountSecret(
        encryptedSuri: (map['encryptedSuri']! as Blob).bytes,
        encryptionKeySalt: (map['encryptionKeySalt']! as Blob).bytes,
        passwordHash: (map['passwordHash']! as Blob).bytes,
        passwordSalt: (map['passwordSalt']! as Blob).bytes,
      ),
    );
  }
}
