import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';

part 'artifact.g.dart';

@HiveType(typeId: 0)
class Artifact extends EquatableEntity {
  @HiveField(0)
  @override
  final String uid;

  @HiveField(1)
  final String filePath;

  @HiveField(2)
  @override
  final DateTime createAt;

  @HiveField(3)
  @override
  final DateTime updateAt;

  @HiveField(4)
  @override
  final int position;

  Artifact({
    required this.uid,
    required this.filePath,
    required this.createAt,
    required this.updateAt,
    this.position = 1,
  })  : assert(uid.isNotEmpty),
        assert(filePath.isNotEmpty);

  String get fileName => basename(filePath);

  @override
  List<Object?> get props => [
        uid,
        filePath,
      ];
}
