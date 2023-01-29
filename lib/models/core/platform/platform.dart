import 'package:firebase_stacktrace_decoder/models/models.dart';

abstract class Platform {
  final PlatformType type;
  final List<Artifact> artifacts;

  const Platform({
    required this.type,
    required this.artifacts,
  });
}

enum PlatformType {
  android,
  ios,
  linux,
  macos,
  windows,
  fuchsia,
}
