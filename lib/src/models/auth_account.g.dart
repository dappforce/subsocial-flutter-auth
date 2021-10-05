// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_account.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthAccountAdapter extends TypeAdapter<_$_AuthAccount> {
  @override
  final int typeId = 1;

  @override
  _$_AuthAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_AuthAccount(
      localName: fields[0] as String,
      publicKey: fields[1] as String,
      accountSecret: fields[2] as AccountSecret,
    );
  }

  @override
  void write(BinaryWriter writer, _$_AuthAccount obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.localName)
      ..writeByte(1)
      ..write(obj.publicKey)
      ..writeByte(2)
      ..write(obj.accountSecret);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AccountSecretAdapter extends TypeAdapter<_$_AccountSecret> {
  @override
  final int typeId = 2;

  @override
  _$_AccountSecret read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return _$_AccountSecret(
      encryptedSuri: fields[0] as Uint8List,
      encryptionKeySalt: fields[1] as Uint8List,
      passwordHash: fields[2] as Uint8List,
      passwordSalt: fields[3] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, _$_AccountSecret obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.encryptedSuri)
      ..writeByte(1)
      ..write(obj.encryptionKeySalt)
      ..writeByte(2)
      ..write(obj.passwordHash)
      ..writeByte(3)
      ..write(obj.passwordSalt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountSecretAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
