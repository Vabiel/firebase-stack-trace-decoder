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
  String toString() {
    return 'Project{uid: $uid, name: $name, version: '
        '$version, platforms: $platforms}';
  }
}
