import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// [AuthAccount] represents an account
@immutable
class AuthAccount {
  /// A name that used only locally to identify the account.
  final String localName;

  /// The public key of this account.
  final String publicKey;

  /// Creates [AuthAccount]
  const AuthAccount({
    required this.localName,
    required this.publicKey,
  });

  /// @nodoc
  AuthAccount copyWith({
    String? localName,
    String? publicKey,
  }) {
    return AuthAccount(
      localName: localName ?? this.localName,
      publicKey: publicKey ?? this.publicKey,
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

  List<Object?> get _props => [localName, publicKey];

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
