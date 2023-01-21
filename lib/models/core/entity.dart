// import 'package:innim_lib/database.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// import '../models.dart';
//
// /// Модель сущности.
// ///
// /// Подразумевается что сущность записывается в БД.
// abstract class Entity extends Model {
//   /// Уникальный идентификатор.
//   final String uid;
//
//   /// `true`, если модель помечена как удаленная.
//   @JsonKey(fromJson: boolFromJsonAny)
//   final bool isRemoved;
//
//   /// Дата создания модели.
//   final DateTime created;
//
//   /// Дата последнего изменения модели.
//   final DateTime modified;
//
//   const Entity(this.uid, this.isRemoved, this.created, this.modified)
//       : assert(uid != null && uid != ""),
//         assert(isRemoved != null),
//         assert(created != null),
//         assert(modified != null),
//         super();
// }
//
// /// Типы сущностей.
// enum EntityType {
//   /// Транзакция
//   Transaction,
//
//   /// Категория.
//   Category
// }
