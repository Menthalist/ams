import 'package:ams_mobile/layout/AppLayout.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/view/connexion/Login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

class MyApp extends StatefulWidget {
  final dynamic accessToken;
  final dynamic refreshToken;

  const MyApp(
      {super.key, required this.accessToken, required this.refreshToken});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final EtatRealisationProvider etatRealisationProvider =
      EtatRealisationProvider();

  @override
  void initState() {
    // TODO: implement initState
    etatRealisationProvider.getItems();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tokens = {
      "accessToken": widget.accessToken,
      "refreshToken": widget.refreshToken
    };

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: this.etatRealisationProvider,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: widget.accessToken != null
            ? JwtDecoder.isExpired(widget.accessToken)
                ? const Login()
                : const AppLayout()
            : const Login(),
      ),
    );
  }
}
