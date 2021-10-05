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

_Dummy _$_DummyFromJson(Map<String, dynamic> json) {
  return __Dummy.fromJson(json);
}

/// @nodoc
class _$_DummyTearOff {
  const _$_DummyTearOff();

  __Dummy call() {
    return const __Dummy();
  }

  _Dummy fromJson(Map<String, Object> json) {
    return _Dummy.fromJson(json);
  }
}

/// @nodoc
const _$Dummy = _$_DummyTearOff();

/// @nodoc
mixin _$_Dummy {
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$DummyCopyWith<$Res> {
  factory _$DummyCopyWith(_Dummy value, $Res Function(_Dummy) then) =
      __$DummyCopyWithImpl<$Res>;
}

/// @nodoc
class __$DummyCopyWithImpl<$Res> implements _$DummyCopyWith<$Res> {
  __$DummyCopyWithImpl(this._value, this._then);

  final _Dummy _value;
  // ignore: unused_field
  final $Res Function(_Dummy) _then;
}

/// @nodoc
abstract class _$_DummyCopyWith<$Res> {
  factory _$_DummyCopyWith(__Dummy value, $Res Function(__Dummy) then) =
      __$_DummyCopyWithImpl<$Res>;
}

/// @nodoc
class __$_DummyCopyWithImpl<$Res> extends __$DummyCopyWithImpl<$Res>
    implements _$_DummyCopyWith<$Res> {
  __$_DummyCopyWithImpl(__Dummy _value, $Res Function(__Dummy) _then)
      : super(_value, (v) => _then(v as __Dummy));

  @override
  __Dummy get _value => super._value as __Dummy;
}

/// @nodoc
@JsonSerializable()
class _$__Dummy implements __Dummy {
  const _$__Dummy();

  factory _$__Dummy.fromJson(Map<String, dynamic> json) =>
      _$$__DummyFromJson(json);

  @override
  String toString() {
    return '_Dummy()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is __Dummy);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$__DummyToJson(this);
  }
}

abstract class __Dummy implements _Dummy {
  const factory __Dummy() = _$__Dummy;

  factory __Dummy.fromJson(Map<String, dynamic> json) = _$__Dummy.fromJson;
}

/// @nodoc
class _$AuthAccountTearOff {
  const _$AuthAccountTearOff();

  _AuthAccount call(
      {@HiveField(0) required String localName,
      @HiveField(1) required String publicKey,
      @HiveField(2) required AccountSecret accountSecret}) {
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
  @HiveField(0)
  String get localName => throw _privateConstructorUsedError;

  /// The public key of this account.
  @HiveField(1)
  String get publicKey => throw _privateConstructorUsedError;

  /// Contains the information used to d/encrypt the suri.
  @HiveField(2)
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
  $Res call(
      {@HiveField(0) String localName,
      @HiveField(1) String publicKey,
      @HiveField(2) AccountSecret accountSecret});

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
  $Res call(
      {@HiveField(0) String localName,
      @HiveField(1) String publicKey,
      @HiveField(2) AccountSecret accountSecret});

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

@HiveType(typeId: 1)
class _$_AuthAccount implements _AuthAccount {
  const _$_AuthAccount(
      {@HiveField(0) required this.localName,
      @HiveField(1) required this.publicKey,
      @HiveField(2) required this.accountSecret});

  @override

  /// A name that used only locally to identify the account.
  @HiveField(0)
  final String localName;
  @override

  /// The public key of this account.
  @HiveField(1)
  final String publicKey;
  @override

  /// Contains the information used to d/encrypt the suri.
  @HiveField(2)
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
      {@HiveField(0) required String localName,
      @HiveField(1) required String publicKey,
      @HiveField(2) required AccountSecret accountSecret}) = _$_AuthAccount;

  @override

  /// A name that used only locally to identify the account.
  @HiveField(0)
  String get localName => throw _privateConstructorUsedError;
  @override

  /// The public key of this account.
  @HiveField(1)
  String get publicKey => throw _privateConstructorUsedError;
  @override

  /// Contains the information used to d/encrypt the suri.
  @HiveField(2)
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
      {@HiveField(0) required Uint8List encryptedSuri,
      @HiveField(1) required Uint8List encryptionKeySalt,
      @HiveField(2) required Uint8List passwordHash,
      @HiveField(3) required Uint8List passwordSalt}) {
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
  @HiveField(0)
  Uint8List get encryptedSuri => throw _privateConstructorUsedError;

  /// Salt used to drive the encryption key from password.
  @HiveField(1)
  Uint8List get encryptionKeySalt => throw _privateConstructorUsedError;

  /// Hash used to verify the password.
  @HiveField(2)
  Uint8List get passwordHash => throw _privateConstructorUsedError;

  /// Salt used to hash the password.
  @HiveField(3)
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
      {@HiveField(0) Uint8List encryptedSuri,
      @HiveField(1) Uint8List encryptionKeySalt,
      @HiveField(2) Uint8List passwordHash,
      @HiveField(3) Uint8List passwordSalt});
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
      {@HiveField(0) Uint8List encryptedSuri,
      @HiveField(1) Uint8List encryptionKeySalt,
      @HiveField(2) Uint8List passwordHash,
      @HiveField(3) Uint8List passwordSalt});
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

@HiveType(typeId: 2)
class _$_AccountSecret extends _AccountSecret {
  const _$_AccountSecret(
      {@HiveField(0) required this.encryptedSuri,
      @HiveField(1) required this.encryptionKeySalt,
      @HiveField(2) required this.passwordHash,
      @HiveField(3) required this.passwordSalt})
      : super._();

  @override

  /// The encrypted suri.
  @HiveField(0)
  final Uint8List encryptedSuri;
  @override

  /// Salt used to drive the encryption key from password.
  @HiveField(1)
  final Uint8List encryptionKeySalt;
  @override

  /// Hash used to verify the password.
  @HiveField(2)
  final Uint8List passwordHash;
  @override

  /// Salt used to hash the password.
  @HiveField(3)
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
      {@HiveField(0) required Uint8List encryptedSuri,
      @HiveField(1) required Uint8List encryptionKeySalt,
      @HiveField(2) required Uint8List passwordHash,
      @HiveField(3) required Uint8List passwordSalt}) = _$_AccountSecret;
  const _AccountSecret._() : super._();

  @override

  /// The encrypted suri.
  @HiveField(0)
  Uint8List get encryptedSuri => throw _privateConstructorUsedError;
  @override

  /// Salt used to drive the encryption key from password.
  @HiveField(1)
  Uint8List get encryptionKeySalt => throw _privateConstructorUsedError;
  @override

  /// Hash used to verify the password.
  @HiveField(2)
  Uint8List get passwordHash => throw _privateConstructorUsedError;
  @override

  /// Salt used to hash the password.
  @HiveField(3)
  Uint8List get passwordSalt => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AccountSecretCopyWith<_AccountSecret> get copyWith =>
      throw _privateConstructorUsedError;
}
