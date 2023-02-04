// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      uid: json['uid'] as String,
      name: json['name'] as String,
      version: json['version'] as String,
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((e) => Platform.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isRemoved: json['isRemoved'] as bool? ?? false,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'uid': instance.uid,
      'isRemoved': instance.isRemoved,
      'name': instance.name,
      'version': instance.version,
      'platforms': instance.platforms,
    };
