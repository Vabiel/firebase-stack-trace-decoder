import 'package:firebase_stacktrace_decoder/application/app.dart';
import 'package:firebase_stacktrace_decoder/application/di_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  runApp(Phoenix(child: DiInitializer(child: FirebaseStacktraceDecoder())));
}
