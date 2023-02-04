import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project extends Entity {
  final String name;
  final String version;
  final List<Platform> platforms;

  Project({
    required super.uid,
    required this.name,
    required this.version,
    this.platforms = const [],
    super.isRemoved,
  })  : assert(name.isNotEmpty),
        assert(version.isNotEmpty);

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  bool get isEmpty => platforms.isEmpty;

  bool get isNotEmpty => platforms.isNotEmpty;

  Project copyWith({
    String? name,
    String? version,
    List<Platform>? platforms,
  }) {
    return Project(
      uid: uid,
      name: name ?? this.name,
      version: version ?? this.version,
      platforms: platforms ?? this.platforms,
    );
  }

  @override
  List<Object?> get props => [
        uid,
        name,
        version,
        platforms,
      ];

  @override
  Map<String, dynamic> toJson() {
    return _$ProjectToJson(this);
  }
}
