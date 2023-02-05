import 'package:firebase_stacktrace_decoder/application/routes.dart';
import 'package:firebase_stacktrace_decoder/application/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'localization.dart';

class FirebaseStacktraceDecoder extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  FirebaseStacktraceDecoder({super.key}) {
    // Needed to refer to plugins during initialization
    WidgetsFlutterBinding.ensureInitialized();

    // block orientation change
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    Bloc.observer = _ApplicationBlocObserver(logEnabled: false);
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: AppTheme.theme,
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorKey: _navigatorKey,
      localizationsDelegates: _createLocalization(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }

  /// Creates a list of localization delegates for the application.
  List<LocalizationsDelegate<dynamic>> _createLocalization() => [
        AppLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ];
}

/// Auxiliary class for global tracking of the action with all blocs
class _ApplicationBlocObserver extends BlocObserver {
  final bool logEnabled;

  _ApplicationBlocObserver({this.logEnabled = false});

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (logEnabled) _logTransition(bloc, transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    debugPrint('️Error:\n$error. Stacktrace: $stacktrace');
  }

  void _logTransition(Bloc bloc, Transition transition) {
    final title = '================= [ ${bloc.runtimeType} ] =================';
    final separator = List.generate(title.length, (index) => '=').join();
    debugPrint('''
$title
Event     : ${transition.event}
Prev state: ${transition.currentState}
Next state: ${transition.nextState}
$separator
''');
  }
}
