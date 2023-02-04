// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artifact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artifact _$ArtifactFromJson(Map<String, dynamic> json) => Artifact(
      uid: json['uid'] as String,
      filePath: json['filePath'] as String,
      isRemoved: json['isRemoved'] as bool? ?? false,
    );

Map<String, dynamic> _$ArtifactToJson(Artifact instance) => <String, dynamic>{
      'uid': instance.uid,
      'isRemoved': instance.isRemoved,
      'filePath': instance.filePath,
    };
