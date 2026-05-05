import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive_ce/hive.dart';
import 'package:path/path.dart';

part 'artifact.g.dart';

@HiveType(typeId: 3)
class Artifact extends Entity {
  @HiveField(0)
  @override
  final String uid;

  @HiveField(1)
  final String filePath;

  @HiveField(2)
  @override
  final int position;

  Artifact({
    required this.filePath,
    required this.uid,
    this.position = 1,
  })  : assert(uid.isNotEmpty),
        assert(filePath.isNotEmpty);

  String get filename => basename(filePath);

  @override
  List<Object?> get props => [
        uid,
        filePath,
      ];

  Artifact copyWith({
    String? filePath,
    int? position,
  }) {
    return Artifact(
      uid: uid,
      filePath: filePath ?? this.filePath,
      position: position ?? this.position,
    );
  }
}
