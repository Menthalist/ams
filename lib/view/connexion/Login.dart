import 'package:shared_preferences/shared_preferences.dart';
import 'package:ams_mobile/controller/AuthController/AuthController.dart';
import 'package:ams_mobile/layout/AppLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import '../../MdpOublie.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthenticationController _authenticationController =
      AuthenticationController();
  late SharedPreferences prefs;

  bool _password = false;

  bool loading = false;
  bool incorrectLogin = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void seConnecter() async {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      setState(() {
        loading = true;
        incorrectLogin = false;
      });

      var authData = await _authenticationController.login(
          usernameController.text, passwordController.text);
      // set loading false
      setState(() {
        loading = false;
      });

      if (authData['refreshToken'] != null && authData['accessToken'] != null) {
        // set access and refresh tokens
        prefs.setString('refreshToken', authData['refreshToken']);
        prefs.setString('accessToken', authData['accessToken']);

        // set user data
        prefs.setInt('IdByRole', authData['user']['id']);
        prefs.setString('user', jsonEncode(authData['user']['user']));
        //print(authData);
        prefs.setString('telephone', authData['user']['telephone']);
        prefs.setString('trigramme', authData['user']['trigramme']);
        //prefs.setString('secteurPrimaire', authData['user']['secteurPrimaire']);

        //prefs.setString(
        //'secteurSecondaire', authData['user']['secteurSecondaire']);
        prefs.setString('stats', jsonEncode(authData['user']['stats']));

        setState(() {
          incorrectLogin = false;
        });

        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return AppLayout(
              authData: authData,
            );
          }));
        }
      } else {
        setState(() {
          incorrectLogin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: ListView(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.only(top: 97),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/logo.png"),
                      fit: BoxFit.fill),
                )),
          ),
          const SizedBox(
            height: 27,
          ),
          const Text(
            "CONNEXION",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Connectez vous et réaliser des etats de lieux",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 40,
          ),
          Container(
              margin: const EdgeInsets.only(left: 11),
              child: const Text(
                "E-mail addresse",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.08,
            margin: const EdgeInsets.only(left: 11, right: 11, top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 1.0, color: const Color.fromARGB(218, 219, 219, 215)),
            ),
            child: TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "",
                contentPadding: const EdgeInsets.only(left: 9, top: 15),
                hintStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                suffixIcon: Icon(
                  Icons.mail,
                  color: Colors.grey.withOpacity(1),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              margin: const EdgeInsets.only(left: 11, top: 10),
              child: const Text(
                "Mot de passe",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.08,
            margin: const EdgeInsets.only(left: 11, right: 11, top: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 1.0, color: const Color.fromARGB(218, 219, 219, 215)),
            ),
            child: TextFormField(
              controller: passwordController,
              obscureText: _password,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
                contentPadding: const EdgeInsets.only(left: 9, top: 15),
                suffixIcon: IconButton(
                    icon: Icon(
                        !_password ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.withOpacity(1)),
                    onPressed: () {
                      setState(() {
                        _password = !_password;
                      });
                    }),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            child: Container(
              margin: const EdgeInsets.only(left: 11, right: 11, top: 5),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.08,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  (() {
                    if (loading) {
                      return "CONNEXION EN COURS...";
                    }
                    return "SE CONNECTER";
                  })(),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              seConnecter();
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => home()));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.center,
              child: InkWell(
                child: const Text(
                  "mot de passe oublié",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      decoration: TextDecoration.underline),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>   Mdp()));
                },
              )),
          const SizedBox(
            height: 170,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "AMEXPERT",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
