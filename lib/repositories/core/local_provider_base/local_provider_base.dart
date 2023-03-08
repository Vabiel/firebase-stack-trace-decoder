import 'package:firebase_stacktrace_decoder/models/models.dart';
import 'package:hive/hive.dart';

abstract class LocalProviderBase<T extends Entity> {
  var _initialized = false;

  bool get isInitialized => _initialized;

  final String boxName;
  late final Box<T> _box;

  LocalProviderBase(this.boxName);

  Future<void> initialize() async {
    if (_initialized) {
      assert(false, 'Box<$boxName> Already initialized');
      return;
    }
    _initialized = true;

    _box = await Hive.openBox<T>(boxName);
  }

  Future<List<T>> getAll() async {
    return _box.values.toList();
  }

  Future<T?> getByUid(String uid) async {
    return _box.get(uid);
  }

  Future<void> save(T value) async {
    await _box.put(value.uid, value);
  }

  Future<void> saveAll(List<T> list) async {
    final items = <dynamic, T>{for (final value in list) value.uid: value};
    await _box.putAll(items);
  }

  Future<void> delete(T item) async {
    await deleteByUid(item.uid);
  }

  Future<void> deleteByUid(String uid) async {
    await _box.delete(uid);
  }

  Future<void> deleteAll(List<T> list) async {
    final items = list.map((e) => e.uid);
    await deleteAllByUids(items);
  }

  Future<void> deleteAllByUids(Iterable<String> uids) async {
    await _box.deleteAll(uids);
  }
}
