import 'package:firebase_stacktrace_decoder/application/extensions/bloc_extension/bloc_extension.dart';
import 'package:firebase_stacktrace_decoder/blocs/app/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<AppBloc>();
    bloc.waitForState<AppReadySuccess>().then((value) {
      bloc.add(const AppLaunchScreenShown());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
          child: Image.asset(
        'assets/dash.png',
        fit: BoxFit.contain,
      )),
    );
  }
}
