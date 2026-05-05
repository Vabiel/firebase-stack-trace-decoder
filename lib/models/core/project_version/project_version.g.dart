// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_version.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectVersionAdapter extends TypeAdapter<ProjectVersion> {
  @override
  final typeId = 4;

  @override
  ProjectVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectVersion(
      uid: fields[0] as String,
      version: fields[1] as String,
      platforms:
          fields[2] == null ? const [] : (fields[2] as List).cast<Platform>(),
      position: fields[3] == null ? -1 : (fields[3] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ProjectVersion obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.version)
      ..writeByte(2)
      ..write(obj.platforms)
      ..writeByte(3)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
