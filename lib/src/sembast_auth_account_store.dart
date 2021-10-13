import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:subsocial_flutter_auth/src/auth_account_store.dart';
import 'package:subsocial_flutter_auth/src/models/auth_account.dart';
import 'package:subsocial_flutter_auth/src/models/secret_config.dart';

/// [SembastAuthAccountStore] stores accounts and the current active account on disk
/// using sembast package.
class SembastAuthAccountStore extends ChangeNotifier
    implements AuthAccountStore {
  late Completer<Database> _databaseCompleter;
  final _accountsStore = StoreRef<String, Map<String, Object?>>('accounts');
  final _activeAccountStore = StoreRef<int, String>('active_account');

  /// Creates [SembastAuthAccountStore].
  SembastAuthAccountStore(
    String databasePath, {
    DatabaseFactory? databaseFactory,
  }) {
    _databaseCompleter = Completer()
      ..complete(_openDatabase(
        databasePath,
        databaseFactory: databaseFactory,
      ));
  }

  static Future<Database> _openDatabase(
    String dbPath, {
    DatabaseFactory? databaseFactory,
  }) async {
    final DatabaseFactory dbFactory = databaseFactory ?? databaseFactoryIo;
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
  Future<List<AuthAccount>> getStoredAccounts() async {
    return UnmodifiableListView((await _accountsStore.find(await _db))
        .map(
          (snapshot) =>
              SembastAuthAccountMapper.fromNullableSembastMap(snapshot.value),
        )
        .whereNotNull()
        .toList());
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
    return MapEntry(
      publicKey,
      {
        'name': localName,
        'publicKey': publicKey,
        'accountSecretConfig': accountSecretConfig.toMap(),
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
      accountSecretConfig: AccountSecretConfig.fromMap(
          map['accountSecretConfig']! as Map<String, dynamic>),
    );
  }
}
