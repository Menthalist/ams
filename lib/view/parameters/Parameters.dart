import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Parameters extends StatefulWidget {
  const Parameters({super.key});

  @override
  State<Parameters> createState() => _ParametersState();
}

class _ParametersState extends State<Parameters> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return const Scaffold(
      body: Text("fabrice"),
    );
  }
}
