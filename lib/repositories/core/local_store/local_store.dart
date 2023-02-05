import 'package:firebase_stacktrace_decoder/application/path_provider.dart';
import 'package:hive/hive.dart';

/// Локальное хранилище данных.
class LocalStore {
  static bool _initialized = false;

  /// Determines if DI has already been initialized.
  static bool get isInitialized => _initialized;

  final ApplicationPathProvider pathProvider;

  LocalStore(this.pathProvider);

  Future<void> initialize() async {
    if (_initialized) {
      assert(false, 'LocalStore Already initialized');
      return;
    }
    _initialized = true;

    final directory = await pathProvider.getDatabaseDir();
    Hive.init(directory.path);
  }
}
