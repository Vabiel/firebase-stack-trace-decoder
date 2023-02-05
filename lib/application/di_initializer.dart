import 'package:firebase_stacktrace_decoder/application/path_provider.dart';
import 'package:firebase_stacktrace_decoder/cmd/cmd.dart';
import 'package:firebase_stacktrace_decoder/cmd/flutter_cmd.dart';
import 'package:firebase_stacktrace_decoder/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

/// Dependency management initializer.
class DependencyInjectionInitializer {
  static bool _initialized = false;

  /// Determines if DI has already been initialized.
  static bool get isInitialized => _initialized;

  /// Initializes dependency management.
  static void initialize() {
    if (_initialized) {
      assert(false, 'DI Already initialized');
      return;
    }
    _initialized = true;

    _registerCommon();
    _registerProviders();
  }

  static void _registerCommon() {
    final di = GetIt.instance;
    // Providers are registered in [_registerProviders].
    di.registerSingleton(ApplicationPathProvider());
    di.registerSingleton(LocalStore(di.get<ApplicationPathProvider>()));
    di.registerSingleton(Cmd());
    di.registerSingleton(FlutterCmd(di.get<Cmd>()));
  }

  static void _registerProviders() async {
    final di = GetIt.instance;
    final db = di.get<LocalStore>();
    await db.initialize();
    di.registerSingleton(ArtifactLocalProvider());
    di.registerSingleton(PlatformLocalProvider());
    di.registerSingleton(ProjectLocalProvider());
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
