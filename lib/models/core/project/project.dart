import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';

part 'project.g.dart';

@HiveType(typeId: 0)
class Project extends EquatableEntity {
  @HiveField(0)
  @override
  final String uid;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String version;

  @HiveField(3)
  final List<Platform> platforms;

  @HiveField(4)
  @override
  final DateTime createAt;

  @HiveField(5)
  @override
  final DateTime updateAt;

  @HiveField(6)
  @override
  final int position;

  Project({
    required this.uid,
    required this.name,
    required this.version,
    required this.createAt,
    required this.updateAt,
    this.position = 1,
    this.platforms = const [],
  })  : assert(name.isNotEmpty),
        assert(version.isNotEmpty);

  bool get isEmpty => platforms.isEmpty;

  bool get isNotEmpty => platforms.isNotEmpty;

  @override
  List<Object?> get props => [
        uid,
        name,
        version,
        platforms,
      ];

  Project copyWith({
    bool? isRemoved,
    String? name,
    String? version,
    List<Platform>? platforms,
    DateTime? createAt,
    DateTime? updateAt,
    int? position,
  }) {
    return Project(
      uid: uid,
      name: name ?? this.name,
      version: version ?? this.version,
      platforms: platforms ?? this.platforms,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      position: position ?? this.position,
    );
  }
}
