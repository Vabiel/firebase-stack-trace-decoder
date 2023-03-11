import 'package:firebase_stacktrace_decoder/application/path_provider.dart';
import 'package:firebase_stacktrace_decoder/cmd/cmd.dart';
import 'package:firebase_stacktrace_decoder/cmd/flutter_cmd.dart';
import 'package:firebase_stacktrace_decoder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../models/models.dart';

/// Dependency management initializer.
class DependencyInjectionInitializer {
  static bool _initialized = false;

  /// Determines if DI has already been initialized.
  static bool get isInitialized => _initialized;

  /// Initializes dependency management.
  static Future<void> initialize() async {
    if (_initialized) {
      assert(false, 'DI Already initialized');
      return;
    }
    _initialized = true;

    await _registerCommon();
    await _registerProviders();
    await _initializeProviders();
  }

  static Future<void> _registerCommon() async {
    // Providers are registered in [_registerProviders].
    Get.put(ApplicationPathProvider());
    Get.put(LocalStore(Get.find()));
    Get.put(Cmd());
    Get.put(FlutterCmd(Get.find()));
  }

  static Future<void> _registerProviders() async {
    Get.put(ArtifactLocalProvider());
    Get.put(PlatformLocalProvider());
    Get.put(ProjectLocalProvider());
    Hive.registerAdapter(PlatformTypeAdapter());
    Hive.registerAdapter(ArtifactAdapter());
    Hive.registerAdapter(PlatformAdapter());
    Hive.registerAdapter(ProjectAdapter());
  }

  static Future<void> _initializeProviders() async {
    final db = Get.find<LocalStore>();
    await db.initialize();
    final projectLocalProvider = Get.find<ProjectLocalProvider>();
    await projectLocalProvider.initialize();
  }

  DependencyInjectionInitializer._();
}

/// Di initialization widget.
///
/// Required for correct operation of the [Phoenix] package.
/// Widget allows correct initialization of [DependencyInjectionInitializer]
/// When restarting the application via [Phoenix] and when waking the application from sleep.
class DiInitializer extends StatefulWidget {
  final Widget child;

  const DiInitializer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DiInitializerState();
}

class _DiInitializerState extends State<DiInitializer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!DependencyInjectionInitializer.isInitialized) {
      DependencyInjectionInitializer.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
