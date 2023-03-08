import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';
import 'package:list_ext/list_ext.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends Entity {
  // @HiveField(0)
  // final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String version;

  @HiveField(3)
  final List<Platform> platforms;

  // @HiveField(4)
  // final int position;

  @HiveField(5)
  final String? preview;

  Project({
    required super.uid,
    required this.name,
    required this.version,
    super.position = -1,
    this.platforms = const [],
    this.preview,
  })  : assert(name.isNotEmpty),
        assert(version.isNotEmpty);

  bool get hasPlatforms => platforms.countWhere((e) => e.isActive) > 0;

  bool get hasAnyPlatforms => platforms.isNotEmpty;

  int get activePlatformsCount => platforms.countWhere((e) => e.isActive);

  @override
  List<Object?> get props => [
        uid,
        name,
        version,
        platforms,
        position,
        preview,
      ];

  Project copyWith({
    String? name,
    String? version,
    String? preview,
    List<Platform>? platforms,
    int? position,
    bool nullablePreview = true,
  }) {
    return Project(
      uid: uid,
      name: name ?? this.name,
      version: version ?? this.version,
      platforms: platforms ?? this.platforms,
      position: position ?? this.position,
      preview: nullablePreview ? preview : preview ?? this.preview,
    );
  }
}
