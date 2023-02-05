// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Platform _$PlatformFromJson(Map<String, dynamic> json) => Platform(
      uid: json['uid'] as String,
      type: $enumDecode(_$PlatformTypeEnumMap, json['type']),
      artifacts: (json['artifacts'] as List<dynamic>)
          .map((e) => Artifact.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRemoved: json['isRemoved'] as bool? ?? false,
    );

Map<String, dynamic> _$PlatformToJson(Platform instance) => <String, dynamic>{
      'uid': instance.uid,
      'isRemoved': instance.isRemoved,
      'type': _$PlatformTypeEnumMap[instance.type]!,
      'artifacts': instance.artifacts.map((e) => e.toJson()),
    };

const _$PlatformTypeEnumMap = {
  PlatformType.android: 'android',
  PlatformType.ios: 'ios',
  PlatformType.linux: 'linux',
  PlatformType.macos: 'macos',
  PlatformType.windows: 'windows',
  PlatformType.fuchsia: 'fuchsia',
};
