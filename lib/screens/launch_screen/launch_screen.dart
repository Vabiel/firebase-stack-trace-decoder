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

    context.read<AppBloc>().add(const AppLaunchScreenHidden());
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.blue);
  }
}
