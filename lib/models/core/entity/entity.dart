import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  final String uid;
  final bool isRemoved;

  const Entity({required this.uid, this.isRemoved = false});

  Map<String, dynamic> toJson();
}
