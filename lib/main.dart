import 'package:ams_mobile/layout/AppLayout.dart';
import 'package:ams_mobile/view/connexion/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    accessToken: prefs.getString("accessToken"),
    refreshToken: prefs.getString("refreshToken"),
  ));
}

class MyApp extends StatelessWidget {
  final dynamic accessToken;
  final dynamic refreshToken;

  const MyApp(
      {super.key, required this.accessToken, required this.refreshToken});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     var tokens = {"accessToken": accessToken, "refreshToken": refreshToken};

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  accessToken != null
          ? JwtDecoder.isExpired(accessToken) ? const Login() : const AppLayout() : const Login(),
    );
  }
}
