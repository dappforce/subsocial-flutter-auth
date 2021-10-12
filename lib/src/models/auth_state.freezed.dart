// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$AuthStateTearOff {
  const _$AuthStateTearOff();

  _AuthState call(
      {required AuthAccount? activeAccount,
      required List<AuthAccount> accounts}) {
    return _AuthState(
      activeAccount: activeAccount,
      accounts: accounts,
    );
  }
}

/// @nodoc
const $AuthState = _$AuthStateTearOff();

/// @nodoc
mixin _$AuthState {
  /// The current active account.
  AuthAccount? get activeAccount => throw _privateConstructorUsedError;

  /// List of the current stored accounts.
  List<AuthAccount> get accounts => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res>;
  $Res call({AuthAccount? activeAccount, List<AuthAccount> accounts});

  $AuthAccountCopyWith<$Res>? get activeAccount;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res> implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  final AuthState _value;
  // ignore: unused_field
  final $Res Function(AuthState) _then;

  @override
  $Res call({
    Object? activeAccount = freezed,
    Object? accounts = freezed,
  }) {
    return _then(_value.copyWith(
      activeAccount: activeAccount == freezed
          ? _value.activeAccount
          : activeAccount // ignore: cast_nullable_to_non_nullable
              as AuthAccount?,
      accounts: accounts == freezed
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AuthAccount>,
    ));
  }

  @override
  $AuthAccountCopyWith<$Res>? get activeAccount {
    if (_value.activeAccount == null) {
      return null;
    }

    return $AuthAccountCopyWith<$Res>(_value.activeAccount!, (value) {
      return _then(_value.copyWith(activeAccount: value));
    });
  }
}

/// @nodoc
abstract class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(
          _AuthState value, $Res Function(_AuthState) then) =
      __$AuthStateCopyWithImpl<$Res>;
  @override
  $Res call({AuthAccount? activeAccount, List<AuthAccount> accounts});

  @override
  $AuthAccountCopyWith<$Res>? get activeAccount;
}

/// @nodoc
class __$AuthStateCopyWithImpl<$Res> extends _$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(_AuthState _value, $Res Function(_AuthState) _then)
      : super(_value, (v) => _then(v as _AuthState));

  @override
  _AuthState get _value => super._value as _AuthState;

  @override
  $Res call({
    Object? activeAccount = freezed,
    Object? accounts = freezed,
  }) {
    return _then(_AuthState(
      activeAccount: activeAccount == freezed
          ? _value.activeAccount
          : activeAccount // ignore: cast_nullable_to_non_nullable
              as AuthAccount?,
      accounts: accounts == freezed
          ? _value.accounts
          : accounts // ignore: cast_nullable_to_non_nullable
              as List<AuthAccount>,
    ));
  }
}

/// @nodoc

class _$_AuthState extends _AuthState {
  const _$_AuthState({required this.activeAccount, required this.accounts})
      : super._();

  @override

  /// The current active account.
  final AuthAccount? activeAccount;
  @override

  /// List of the current stored accounts.
  final List<AuthAccount> accounts;

  @override
  String toString() {
    return 'AuthState(activeAccount: $activeAccount, accounts: $accounts)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _AuthState &&
            (identical(other.activeAccount, activeAccount) ||
                const DeepCollectionEquality()
                    .equals(other.activeAccount, activeAccount)) &&
            (identical(other.accounts, accounts) ||
                const DeepCollectionEquality()
                    .equals(other.accounts, accounts)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(activeAccount) ^
      const DeepCollectionEquality().hash(accounts);

  @JsonKey(ignore: true)
  @override
  _$AuthStateCopyWith<_AuthState> get copyWith =>
      __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);
}

abstract class _AuthState extends AuthState {
  const factory _AuthState(
      {required AuthAccount? activeAccount,
      required List<AuthAccount> accounts}) = _$_AuthState;
  const _AuthState._() : super._();

  @override

  /// The current active account.
  AuthAccount? get activeAccount => throw _privateConstructorUsedError;
  @override

  /// List of the current stored accounts.
  List<AuthAccount> get accounts => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$AuthStateCopyWith<_AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}
