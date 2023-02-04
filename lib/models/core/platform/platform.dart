import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'platform.g.dart';

@JsonSerializable()
class Platform extends Entity {
  final PlatformType type;
  final List<Artifact> artifacts;

  const Platform({
    required super.uid,
    required this.type,
    required this.artifacts,
    super.isRemoved,
  });

  factory Platform.fromJson(Map<String, dynamic> json) =>
      _$PlatformFromJson(json);

  @override
  List<Object?> get props => [
        uid,
        type,
        artifacts,
        isRemoved,
      ];

  @override
  Map<String, dynamic> toJson() {
    return _$PlatformToJson(this);
  }
}

enum PlatformType {
  android,
  ios,
  linux,
  macos,
  windows,
  fuchsia,
}
