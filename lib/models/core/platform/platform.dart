import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';

part 'platform.g.dart';

@HiveType(typeId: 1)
class Platform extends Entity {
  // @HiveField(0)
  // final String uid;

  @HiveField(1)
  final PlatformType type;

  @HiveField(2)
  final List<Artifact> artifacts;

  // @HiveField(3)
  // final int position;

  @HiveField(4)
  final bool isActive;

  const Platform({
    required this.type,
    required super.uid,
    super.position = -1,
    this.artifacts = const [],
    this.isActive = true,
  });

  String get name => type.name;

  bool get hasArtifacts => artifacts.isNotEmpty;

  @override
  List<Object?> get props => [
        uid,
        type,
        artifacts,
      ];

  Platform copyWith({
    PlatformType? type,
    List<Artifact>? artifacts,
    DateTime? createAt,
    DateTime? updateAt,
    int? position,
    bool? isActive,
  }) {
    return Platform(
      uid: uid,
      type: type ?? this.type,
      artifacts: artifacts ?? this.artifacts,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
    );
  }
}

@HiveType(typeId: 2)
enum PlatformType {
  @HiveField(0)
  android,
  @HiveField(1)
  ios,
  @HiveField(2)
  linux,
  @HiveField(3)
  macos,
  @HiveField(4)
  windows,
  @HiveField(5)
  fuchsia,
}
