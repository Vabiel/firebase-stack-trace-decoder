import 'package:equatable/equatable.dart';

abstract class Entity extends Equatable {
  String get uid;
  int get position;
}
