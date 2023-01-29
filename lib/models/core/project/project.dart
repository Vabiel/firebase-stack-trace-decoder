import 'package:equatable/equatable.dart';
import 'package:firebase_stacktrace_decoder/models/models.dart';


class Project extends Equatable {
  final String uid;
  final String name;
  final String version;
  final List<Platform> platforms;

  Project({
    required this.uid,
    required this.name,
    required this.version,
    this.platforms = const [],
  })  : assert(name.isNotEmpty),
        assert(version.isNotEmpty);

  @override
  List<Object?> get props => [
        uid,
        name,
        version,
        platforms,
      ];

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
  String toString() {
    return 'Project{uid: $uid, name: $name, version: '
        '$version, platforms: $platforms}';
  }
}
