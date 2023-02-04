import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';

part 'artifact.g.dart';

@JsonSerializable()
class Artifact extends Entity {
  final String filePath;

  Artifact({required super.uid, required this.filePath, super.isRemoved})
      : assert(filePath.isNotEmpty);

  factory Artifact.fromJson(Map<String, dynamic> json) =>
      _$ArtifactFromJson(json);

  String get fileName => basename(filePath);

  @override
  List<Object?> get props => [
        uid,
        filePath,
        isRemoved,
      ];

  @override
  Map<String, dynamic> toJson() {
    return _$ArtifactToJson(this);
  }
}
