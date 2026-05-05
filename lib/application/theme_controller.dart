import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

/// Singleton holding the app's [ThemeMode] preference. Persists the chosen
/// mode to a tiny Hive box so the choice survives restarts.
class ThemeController extends ValueNotifier<ThemeMode> {
  static const _boxName = 'app_settings';
  static const _key = 'theme_mode';

  static final ThemeController instance = ThemeController._(ThemeMode.system);

  ThemeController._(super.value);

  Box<int>? _box;

  Future<void> load() async {
    _box = await Hive.openBox<int>(_boxName);
    final stored = _box!.get(_key);
    if (stored != null && stored >= 0 && stored < ThemeMode.values.length) {
      value = ThemeMode.values[stored];
    }
  }

  void setMode(ThemeMode mode) {
    if (mode == value) return;
    value = mode;
    _box?.put(_key, mode.index);
  }

  /// Cycles light → dark → system → light…
  void cycle() {
    switch (value) {
      case ThemeMode.light:
        setMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setMode(ThemeMode.system);
        break;
      case ThemeMode.system:
        setMode(ThemeMode.light);
        break;
    }
  }
}
