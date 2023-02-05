import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';

abstract class LocalProviderBase<T extends Entity> {
  final String boxName;
  late Box<T> _box;

  LocalProviderBase(this.boxName) {
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<T>(boxName);
  }

  Iterable<T> getAll() => _box.values;

  Future<void> save(T value) async {
    await _box.put(value.uid, value);
  }

  Future<void> saveAll(List<T> list) async {
    final items = <dynamic, T>{for (final value in list) value.uid: value};
    await _box.putAll(items);
  }

  Future<void> delete(T item) async {
    await _box.delete(item.uid);
  }

  Future<void> deleteAll(List<T> list) async {
    final items = list.map((e) => e.uid);
    await _box.deleteAll(items);
  }
}
