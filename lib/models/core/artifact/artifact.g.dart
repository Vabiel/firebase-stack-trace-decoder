// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtifactAdapter extends TypeAdapter<Artifact> {
  @override
  final int typeId = 3;

  @override
  Artifact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artifact(
      uid: fields[0] as String,
      filePath: fields[1] as String,
      position: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Artifact obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.filePath)
      ..writeByte(2)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtifactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
