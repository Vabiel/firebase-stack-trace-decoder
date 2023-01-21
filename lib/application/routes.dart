import 'package:firebase_stacktrace_decoder/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

/// Application paths.
class AppRoutes {
  static const main = "/";

  /// Builds the main content along the path.
  static Widget buildByRoute(BuildContext context, String route, Object? args) {
    switch (route) {
      case AppRoutes.main:
        return const MainScreen();
    }

    throw Exception('Unknown route: $route');
  }

  /// Creates a [Route] given a path string.
  static Route<dynamic> createRoute(String? route, {RouteSettings? settings}) {
    final value = route ?? '';
        return _createRoute<Object>(value, settings);
  }

  /// Creates a [Route] given a path string.
  static Route<T> _createRoute<T>(String route, RouteSettings? settings) {
    return MaterialPageRoute<T>(
      builder: (ctx) => AppRoutes.buildByRoute(ctx, route, settings?.arguments),
      settings: settings,
    );
  }

  /// [Route] factory to pass to [Navigator].
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return createRoute(settings.name, settings: settings);
  }

  static bool untilMain(Route<dynamic> route) {
    return route.settings.name == AppRoutes.main;
  }

  AppRoutes._();
}
