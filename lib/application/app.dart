import 'package:firebase_stacktrace_decoder/application/routes.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:firebase_stacktrace_decoder/application/theme_controller.dart';
import 'package:firebase_stacktrace_decoder/blocs/app/app_bloc.dart';
import 'package:firebase_stacktrace_decoder/screens/launch_screen/launch_screen.dart';
import 'package:firebase_stacktrace_decoder/widgets/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'localization.dart';

class FirebaseStacktraceDecoder extends StatelessWidget {
  static final List<LocalizationsDelegate<dynamic>> _localizationsDelegates = [
    AppLocalizations.delegate,
    DefaultCupertinoLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate
  ];

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  FirebaseStacktraceDecoder({super.key}) {
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AppBloc()..shown()),
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

  Widget _buildLaunchApp() => _buildApp(home: const LaunchScreen());

  Widget _buildMainApp() => _buildApp(
        initialRoute: AppRoutes.main,
        navigatorKey: _navigatorKey,
        onGenerateRoute: _onGenerateRoute,
      );

  Widget _buildApp({
    Widget? home,
    String? initialRoute,
    GlobalKey<NavigatorState>? navigatorKey,
    RouteFactory? onGenerateRoute,
  }) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance,
      builder: (_, mode, __) {
        return MaterialApp(
          onGenerateRoute: onGenerateRoute,
          navigatorKey: navigatorKey,
          initialRoute: initialRoute,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: mode,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: _localizationsDelegates,
          home: home,
          builder: (context, child) {
            // Loader overlay lives INSIDE MaterialApp so the floating card
            // can read theme tokens AND localized strings.
            final t = Theme.of(context).extension<AppTokens>();
            return GlobalLoaderOverlay(
              overlayColor: t?.overlay ?? Colors.black54,
              overlayWidgetBuilder: (_) {
                final l = AppLocalizations.of(context);
                return LoadingCard(
                  title: l.loaderDecodeTitle,
                  subtitle: l.loaderDecodeSubtitle,
                );
              },
              child: child ?? const SizedBox.shrink(),
            );
          },
        );
      },
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    return AppRoutes.createRoute(settings.name, settings: settings);
  }
}
