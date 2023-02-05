import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';

part 'platform.g.dart';

@HiveType(typeId: 0)
class Platform extends EquatableEntity {
  @HiveField(0)
  @override
  final String uid;

  @HiveField(1)
  final PlatformType type;

  @HiveField(2)
  final List<Artifact> artifacts;

  @HiveField(3)
  @override
  final DateTime createAt;

  @HiveField(4)
  @override
  final DateTime updateAt;

  @HiveField(5)
  @override
  final int position;

  const Platform({
    required this.uid,
    required this.type,
    required this.artifacts,
    required this.createAt,
    required this.updateAt,
    this.position = 1,
  });

  @override
  List<Object?> get props => [
        uid,
        type,
        artifacts,
      ];
}

enum PlatformType {
  android,
  ios,
  linux,
  macos,
  windows,
  fuchsia,
}
