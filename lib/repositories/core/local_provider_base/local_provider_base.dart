import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';

abstract class LocalProviderBase<T extends Entity> {
  final String boxName;
  late final _box = Hive.openBox<T>(boxName);

  LocalProviderBase(this.boxName);

  Future<List<T>> getAll() async {
    return (await _box).values.toList();
  }

  Future<T?> getByUid(String uid) async {
    return (await _box).get(uid);
  }

  Future<void> save(T value) async {
    await (await _box).put(value.uid, value);
  }

  Future<void> saveAll(List<T> list) async {
    final items = <dynamic, T>{for (final value in list) value.uid: value};
    await (await _box).putAll(items);
  }

  Future<void> delete(T item) async {
    await deleteByUid(item.uid);
  }

  Future<void> deleteByUid(String uid) async {
    await (await _box).delete(uid);
  }

  Future<void> deleteAll(List<T> list) async {
    final items = list.map((e) => e.uid);
    await deleteAllByUids(items);
  }

  Future<void> deleteAllByUids(Iterable<String> uids) async {
    await (await _box).deleteAll(uids);
  }
}
