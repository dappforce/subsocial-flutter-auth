// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AuthAccountTearOff {
  const _$AuthAccountTearOff();

  _AuthAccount call(
      {required String localName,
      required String publicKey,
      required AccountSecret accountSecret}) {
    return _AuthAccount(
      localName: localName,
      publicKey: publicKey,
      accountSecret: accountSecret,
    );
  }
}

/// @nodoc
const $AuthAccount = _$AuthAccountTearOff();

/// @nodoc
mixin _$AuthAccount {
  /// A name that used only locally to identify the account.
  String get localName => throw _privateConstructorUsedError;

  /// The public key of this account.
  String get publicKey => throw _privateConstructorUsedError;

  /// Contains the information used to d/encrypt the suri.
  AccountSecret get accountSecret => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthAccountCopyWith<AuthAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthAccountCopyWith<$Res> {
  factory $AuthAccountCopyWith(
          AuthAccount value, $Res Function(AuthAccount) then) =
      _$AuthAccountCopyWithImpl<$Res>;
  $Res call({String localName, String publicKey, AccountSecret accountSecret});

  $AccountSecretCopyWith<$Res> get accountSecret;
}

/// @nodoc
class _$AuthAccountCopyWithImpl<$Res> implements $AuthAccountCopyWith<$Res> {
  _$AuthAccountCopyWithImpl(this._value, this._then);

  final AuthAccount _value;
  // ignore: unused_field
  final $Res Function(AuthAccount) _then;

  @override
  $Res call({
    Object? localName = freezed,
    Object? publicKey = freezed,
    Object? accountSecret = freezed,
  }) {
    return _then(_value.copyWith(
      localName: localName == freezed
          ? _value.localName
          : localName // ignore: cast_nullable_to_non_nullable
              as String,
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      accountSecret: accountSecret == freezed
          ? _value.accountSecret
          : accountSecret // ignore: cast_nullable_to_non_nullable
              as AccountSecret,
    ));
  }

  @override
  $AccountSecretCopyWith<$Res> get accountSecret {
    return $AccountSecretCopyWith<$Res>(_value.accountSecret, (value) {
      return _then(_value.copyWith(accountSecret: value));
    });
  }
}

/// @nodoc
abstract class _$AuthAccountCopyWith<$Res>
    implements $AuthAccountCopyWith<$Res> {
  factory _$AuthAccountCopyWith(
          _AuthAccount value, $Res Function(_AuthAccount) then) =
      __$AuthAccountCopyWithImpl<$Res>;
  @override
  $Res call({String localName, String publicKey, AccountSecret accountSecret});

  @override
  $AccountSecretCopyWith<$Res> get accountSecret;
}

/// @nodoc
class __$AuthAccountCopyWithImpl<$Res> extends _$AuthAccountCopyWithImpl<$Res>
    implements _$AuthAccountCopyWith<$Res> {
  __$AuthAccountCopyWithImpl(
      _AuthAccount _value, $Res Function(_AuthAccount) _then)
      : super(_value, (v) => _then(v as _AuthAccount));

  @override
  _AuthAccount get _value => super._value as _AuthAccount;

  @override
  $Res call({
    Object? localName = freezed,
    Object? publicKey = freezed,
    Object? accountSecret = freezed,
  }) {
    return _then(_AuthAccount(
      localName: localName == freezed
          ? _value.localName
          : localName // ignore: cast_nullable_to_non_nullable
              as String,
      publicKey: publicKey == freezed
          ? _value.publicKey
          : publicKey // ignore: cast_nullable_to_non_nullable
              as String,
      accountSecret: accountSecret == freezed
          ? _value.accountSecret
          : accountSecret // ignore: cast_nullable_to_non_nullable
              as AccountSecret,
    ));
  }
}

/// @nodoc

class _$_AuthAccount implements _AuthAccount {
  const _$_AuthAccount(
      {required this.localName,
      required this.publicKey,
      required this.accountSecret});

  @override

  /// A name that used only locally to identify the account.
  final String localName;
  @override

  /// The public key of this account.
  final String publicKey;
  @override

  /// Contains the information used to d/encrypt the suri.
  final AccountSecret accountSecret;

  @override
  String toString() {
    return 'AuthAccount(localName: $localName, publicKey: $publicKey, accountSecret: $accountSecret)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AuthAccount &&
            (identical(other.localName, localName) ||
                const DeepCollectionEquality()
                    .equals(other.localName, localName)) &&
            (identical(other.publicKey, publicKey) ||
                const DeepCollectionEquality()
                    .equals(other.publicKey, publicKey)) &&
            (identical(other.accountSecret, accountSecret) ||
                const DeepCollectionEquality()
                    .equals(other.accountSecret, accountSecret)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(localName) ^
      const DeepCollectionEquality().hash(publicKey) ^
      const DeepCollectionEquality().hash(accountSecret);

  @JsonKey(ignore: true)
  @override
  _$AuthAccountCopyWith<_AuthAccount> get copyWith =>
      __$AuthAccountCopyWithImpl<_AuthAccount>(this, _$identity);
}

abstract class _AuthAccount implements AuthAccount {
  const factory _AuthAccount(
      {required String localName,
      required String publicKey,
      required AccountSecret accountSecret}) = _$_AuthAccount;

  @override

  /// A name that used only locally to identify the account.
  String get localName => throw _privateConstructorUsedError;
  @override

  /// The public key of this account.
  String get publicKey => throw _privateConstructorUsedError;
  @override

  /// Contains the information used to d/encrypt the suri.
  AccountSecret get accountSecret => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AuthAccountCopyWith<_AuthAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
class _$AccountSecretTearOff {
  const _$AccountSecretTearOff();

  _AccountSecret call(
      {required Uint8List encryptedSuri,
      required Uint8List encryptionKeySalt,
      required Uint8List passwordHash,
      required Uint8List passwordSalt}) {
    return _AccountSecret(
      encryptedSuri: encryptedSuri,
      encryptionKeySalt: encryptionKeySalt,
      passwordHash: passwordHash,
      passwordSalt: passwordSalt,
    );
  }
}

/// @nodoc
const $AccountSecret = _$AccountSecretTearOff();

/// @nodoc
mixin _$AccountSecret {
  /// The encrypted suri.
  Uint8List get encryptedSuri => throw _privateConstructorUsedError;

  /// Salt used to drive the encryption key from password.
  Uint8List get encryptionKeySalt => throw _privateConstructorUsedError;

  /// Hash used to verify the password.
  Uint8List get passwordHash => throw _privateConstructorUsedError;

  /// Salt used to hash the password.
  Uint8List get passwordSalt => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountSecretCopyWith<AccountSecret> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountSecretCopyWith<$Res> {
  factory $AccountSecretCopyWith(
          AccountSecret value, $Res Function(AccountSecret) then) =
      _$AccountSecretCopyWithImpl<$Res>;
  $Res call(
      {Uint8List encryptedSuri,
      Uint8List encryptionKeySalt,
      Uint8List passwordHash,
      Uint8List passwordSalt});
}

/// @nodoc
class _$AccountSecretCopyWithImpl<$Res>
    implements $AccountSecretCopyWith<$Res> {
  _$AccountSecretCopyWithImpl(this._value, this._then);

  final AccountSecret _value;
  // ignore: unused_field
  final $Res Function(AccountSecret) _then;

  @override
  $Res call({
    Object? encryptedSuri = freezed,
    Object? encryptionKeySalt = freezed,
    Object? passwordHash = freezed,
    Object? passwordSalt = freezed,
  }) {
    return _then(_value.copyWith(
      encryptedSuri: encryptedSuri == freezed
          ? _value.encryptedSuri
          : encryptedSuri // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      encryptionKeySalt: encryptionKeySalt == freezed
          ? _value.encryptionKeySalt
          : encryptionKeySalt // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      passwordHash: passwordHash == freezed
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      passwordSalt: passwordSalt == freezed
          ? _value.passwordSalt
          : passwordSalt // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc
abstract class _$AccountSecretCopyWith<$Res>
    implements $AccountSecretCopyWith<$Res> {
  factory _$AccountSecretCopyWith(
          _AccountSecret value, $Res Function(_AccountSecret) then) =
      __$AccountSecretCopyWithImpl<$Res>;
  @override
  $Res call(
      {Uint8List encryptedSuri,
      Uint8List encryptionKeySalt,
      Uint8List passwordHash,
      Uint8List passwordSalt});
}

/// @nodoc
class __$AccountSecretCopyWithImpl<$Res>
    extends _$AccountSecretCopyWithImpl<$Res>
    implements _$AccountSecretCopyWith<$Res> {
  __$AccountSecretCopyWithImpl(
      _AccountSecret _value, $Res Function(_AccountSecret) _then)
      : super(_value, (v) => _then(v as _AccountSecret));

  @override
  _AccountSecret get _value => super._value as _AccountSecret;

  @override
  $Res call({
    Object? encryptedSuri = freezed,
    Object? encryptionKeySalt = freezed,
    Object? passwordHash = freezed,
    Object? passwordSalt = freezed,
  }) {
    return _then(_AccountSecret(
      encryptedSuri: encryptedSuri == freezed
          ? _value.encryptedSuri
          : encryptedSuri // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      encryptionKeySalt: encryptionKeySalt == freezed
          ? _value.encryptionKeySalt
          : encryptionKeySalt // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      passwordHash: passwordHash == freezed
          ? _value.passwordHash
          : passwordHash // ignore: cast_nullable_to_non_nullable
              as Uint8List,
      passwordSalt: passwordSalt == freezed
          ? _value.passwordSalt
          : passwordSalt // ignore: cast_nullable_to_non_nullable
              as Uint8List,
    ));
  }
}

/// @nodoc

class _$_AccountSecret extends _AccountSecret {
  const _$_AccountSecret(
      {required this.encryptedSuri,
      required this.encryptionKeySalt,
      required this.passwordHash,
      required this.passwordSalt})
      : super._();

  @override

  /// The encrypted suri.
  final Uint8List encryptedSuri;
  @override

  /// Salt used to drive the encryption key from password.
  final Uint8List encryptionKeySalt;
  @override

  /// Hash used to verify the password.
  final Uint8List passwordHash;
  @override

  /// Salt used to hash the password.
  final Uint8List passwordSalt;

  @override
  String toString() {
    return 'AccountSecret(encryptedSuri: $encryptedSuri, encryptionKeySalt: $encryptionKeySalt, passwordHash: $passwordHash, passwordSalt: $passwordSalt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AccountSecret &&
            (identical(other.encryptedSuri, encryptedSuri) ||
                const DeepCollectionEquality()
                    .equals(other.encryptedSuri, encryptedSuri)) &&
            (identical(other.encryptionKeySalt, encryptionKeySalt) ||
                const DeepCollectionEquality()
                    .equals(other.encryptionKeySalt, encryptionKeySalt)) &&
            (identical(other.passwordHash, passwordHash) ||
                const DeepCollectionEquality()
                    .equals(other.passwordHash, passwordHash)) &&
            (identical(other.passwordSalt, passwordSalt) ||
                const DeepCollectionEquality()
                    .equals(other.passwordSalt, passwordSalt)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(encryptedSuri) ^
      const DeepCollectionEquality().hash(encryptionKeySalt) ^
      const DeepCollectionEquality().hash(passwordHash) ^
      const DeepCollectionEquality().hash(passwordSalt);

  @JsonKey(ignore: true)
  @override
  _$AccountSecretCopyWith<_AccountSecret> get copyWith =>
      __$AccountSecretCopyWithImpl<_AccountSecret>(this, _$identity);
}

abstract class _AccountSecret extends AccountSecret {
  const factory _AccountSecret(
      {required Uint8List encryptedSuri,
      required Uint8List encryptionKeySalt,
      required Uint8List passwordHash,
      required Uint8List passwordSalt}) = _$_AccountSecret;
  const _AccountSecret._() : super._();

  @override

  /// The encrypted suri.
  Uint8List get encryptedSuri => throw _privateConstructorUsedError;
  @override

  /// Salt used to drive the encryption key from password.
  Uint8List get encryptionKeySalt => throw _privateConstructorUsedError;
  @override

  /// Hash used to verify the password.
  Uint8List get passwordHash => throw _privateConstructorUsedError;
  @override

  /// Salt used to hash the password.
  Uint8List get passwordSalt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AccountSecretCopyWith<_AccountSecret> get copyWith =>
      throw _privateConstructorUsedError;
}
