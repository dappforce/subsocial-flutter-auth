import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:subsocial_flutter_auth/src/models/account_secret.dart';

/// [AuthAccount] represents an account
@immutable
class AuthAccount {
  /// A name that used only locally to identify the account.
  final String localName;

  /// The public key of this account.
  final String publicKey;

  /// Contains the information used to d/encrypt the suri.
  final AccountSecret accountSecret;

  /// Creates [AuthAccount]
  const AuthAccount({
    required this.localName,
    required this.publicKey,
    required this.accountSecret,
  });

  /// @nodoc
  AuthAccount copyWith({
    String? localName,
    String? publicKey,
    AccountSecret? accountSecret,
  }) {
    return AuthAccount(
      localName: localName ?? this.localName,
      publicKey: publicKey ?? this.publicKey,
      accountSecret: accountSecret ?? this.accountSecret,
    );
  }

  @override
  String toString() {
    return '''
AuthAccount(
  localName: $localName,
  publicKey: $publicKey,
)''';
  }

  List<Object?> get _props => [localName, publicKey, accountSecret];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAccount &&
          const DeepCollectionEquality().equals(_props, other._props);

  @override
  int get hashCode =>
      _props.map((e) => const DeepCollectionEquality().hash(e)).fold(
            runtimeType.hashCode,
            (previousValue, element) => previousValue ^ element,
          );
}
