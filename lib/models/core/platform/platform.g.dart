// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlatformAdapter extends TypeAdapter<Platform> {
  @override
  final int typeId = 0;

  @override
  Platform read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Platform(
      uid: fields[0] as String,
      type: fields[1] as PlatformType,
      artifacts: (fields[2] as List).cast<Artifact>(),
      createAt: fields[3] as DateTime,
      updateAt: fields[4] as DateTime,
      position: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Platform obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.artifacts)
      ..writeByte(3)
      ..write(obj.createAt)
      ..writeByte(4)
      ..write(obj.updateAt)
      ..writeByte(5)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
