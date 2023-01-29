import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

class Artifact extends Equatable {
  final String filePath;

   Artifact(this.filePath) : assert(filePath.isNotEmpty);

  String get fileName => basename(filePath);

  @override
  List<Object?> get props => [filePath];

  @override
  String toString() {
    return 'Artifact{filePath: $filePath}';
  }
}
