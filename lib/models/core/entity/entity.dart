import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  final String uid;
  final int position;

  const Entity({
    required this.uid,
    required this.position,
  });
}
