import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive_ce/hive.dart';
import 'package:list_ext/list_ext.dart';

part 'project_version.g.dart';

@HiveType(typeId: 4)
class ProjectVersion extends Entity {
  @HiveField(0)
  @override
  final String uid;

  @HiveField(1)
  final String version;

  @HiveField(2)
  final List<Platform> platforms;

  @HiveField(3)
  @override
  final int position;

  ProjectVersion({
    required this.uid,
    required this.version,
    this.platforms = const [],
    this.position = -1,
  })  : assert(uid.isNotEmpty),
        assert(version.isNotEmpty);

  bool get hasPlatforms => platforms.countWhere((e) => e.isActive) > 0;

  bool get hasAnyPlatforms => platforms.isNotEmpty;

  int get activePlatformsCount => platforms.countWhere((e) => e.isActive);

  @override
  List<Object?> get props => [
        uid,
        version,
        platforms,
        position,
      ];

  ProjectVersion copyWith({
    String? version,
    List<Platform>? platforms,
    int? position,
  }) {
    return ProjectVersion(
      uid: uid,
      version: version ?? this.version,
      platforms: platforms ?? this.platforms,
      position: position ?? this.position,
    );
  }
}
