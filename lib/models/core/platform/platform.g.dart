// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlatformAdapter extends TypeAdapter<Platform> {
  @override
  final int typeId = 1;

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
      position: fields[3] as int,
      isActive: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Platform obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.artifacts)
      ..writeByte(3)
      ..write(obj.position)
      ..writeByte(4)
      ..write(obj.isActive);
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

class PlatformTypeAdapter extends TypeAdapter<PlatformType> {
  @override
  final int typeId = 2;

  @override
  PlatformType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlatformType.android;
      case 1:
        return PlatformType.ios;
      case 2:
        return PlatformType.linux;
      case 3:
        return PlatformType.macos;
      case 4:
        return PlatformType.windows;
      case 5:
        return PlatformType.fuchsia;
      default:
        return PlatformType.android;
    }
  }

  @override
  void write(BinaryWriter writer, PlatformType obj) {
    switch (obj) {
      case PlatformType.android:
        writer.writeByte(0);
        break;
      case PlatformType.ios:
        writer.writeByte(1);
        break;
      case PlatformType.linux:
        writer.writeByte(2);
        break;
      case PlatformType.macos:
        writer.writeByte(3);
        break;
      case PlatformType.windows:
        writer.writeByte(4);
        break;
      case PlatformType.fuchsia:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
