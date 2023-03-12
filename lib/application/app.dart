import 'package:firebase_stacktrace_decoder/application/routes.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/blocs/app/app_bloc.dart';
import 'package:firebase_stacktrace_decoder/screens/launch_screen/launch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'localization.dart';

class FirebaseStacktraceDecoder extends StatelessWidget {
  /// Creates a list of localization delegates for the application.
  static final List<LocalizationsDelegate<dynamic>> _localizationsDelegates = [
    AppLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  FirebaseStacktraceDecoder({super.key}) {
    // Needed to refer to plugins during initialization
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc()..shown(),
        ),
      ],
      child: BlocBuilder<AppBloc, AppState>(
        buildWhen: (prev, cur) => cur is! AppReadySuccess && cur is! AppReady,
        builder: (context, state) {
          if (state is AppInitial || state is AppLoadInProgress) {
            return _buildLaunchApp();
          }

          if (state is AppLoadSuccess) {
            return _buildMainApp();
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLaunchApp() {
    return _buildApp(
      home: const LaunchScreen(),
    );
  }

  Widget _buildMainApp() {
    return _buildApp(
      initialRoute: AppRoutes.main,
      navigatorKey: _navigatorKey,
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Widget _buildApp({
    Widget? home,
    String? initialRoute,
    GlobalKey<NavigatorState>? navigatorKey,
    RouteFactory? onGenerateRoute,
    TransitionBuilder? builder,
  }) {
    return GlobalLoaderOverlay(
      overlayColor: Colors.black,
      child: MaterialApp(
        onGenerateRoute: onGenerateRoute,
        navigatorKey: navigatorKey,
        initialRoute: initialRoute,
        theme: AppTheme.theme,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: _localizationsDelegates,
        builder: builder,
        home: home,
      ),
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    return AppRoutes.createRoute(settings.name, settings: settings);
  }
}
