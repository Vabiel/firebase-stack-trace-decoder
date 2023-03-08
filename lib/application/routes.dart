import 'package:firebase_stacktrace_decoder/screens/decode_result/decode_result.dart';
import 'package:firebase_stacktrace_decoder/screens/edit_project/edit_project_screen.dart';
import 'package:firebase_stacktrace_decoder/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

/// Application paths.
class AppRoutes {
  static const main = "/";
  static const editProject = "/editProject";
  static const decodeResult = "/decodeResult";

  /// Builds the main content along the path.
  static Widget buildByRoute(BuildContext context, String route, Object? args) {
    switch (route) {
      case AppRoutes.main:
        return const MainScreen();
      case AppRoutes.editProject:
        return const EditProjectScreen();
      case AppRoutes.decodeResult:
        return const DecodeResultScreen();
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
