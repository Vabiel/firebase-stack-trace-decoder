import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive_ce/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends Entity {
  @HiveField(0)
  @override
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<ProjectVersion> versions;

  @HiveField(3)
  @override
  final int position;

  @HiveField(4)
  final String? preview;

  Project({
    required this.uid,
    required this.name,
    this.versions = const [],
    this.position = -1,
    this.preview,
  }) : assert(name.isNotEmpty);

  bool get hasPlatforms => versions.any((v) => v.hasPlatforms);

  bool get hasAnyPlatforms => versions.any((v) => v.hasAnyPlatforms);

  Iterable<ProjectVersion> get activeVersions =>
      versions.where((v) => v.hasPlatforms);

  @override
  List<Object?> get props => [
        uid,
        name,
        versions,
        position,
        preview,
      ];

  Project copyWith({
    String? name,
    String? preview,
    List<ProjectVersion>? versions,
    int? position,
    bool nullablePreview = true,
  }) {
    return Project(
      uid: uid,
      name: name ?? this.name,
      versions: versions ?? this.versions,
      position: position ?? this.position,
      preview: nullablePreview ? preview : preview ?? this.preview,
    );
  }
}
