import 'package:equatable/equatable.dart';

abstract class EquatableEntity extends Equatable implements Entity {
  const EquatableEntity();
}

abstract class Entity extends Equatable {
  final String uid;
  final DateTime createAt;
  final DateTime updateAt;
  final int position;

  const Entity({
    required this.uid,
    required this.createAt,
    required this.updateAt,
    required this.position,
  });
}
