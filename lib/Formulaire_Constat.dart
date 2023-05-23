import 'dart:io';

import 'package:ams_mobile/Textform_Constat.dart';
import 'package:ams_mobile/camera.dart';
import 'package:ams_mobile/connexion/loginpage.dart';
import 'package:ams_mobile/conteneur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Formulaire_Constat extends StatefulWidget {
  @override
  State<Formulaire_Constat> createState() => _Formulaire_ConstatState();
}

class _Formulaire_ConstatState extends State<Formulaire_Constat> {
  late SharedPreferences globals;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  _Formulaire_ConstatState() {
    selectchoice = constatList[0];
    // _SelectedVal = _EtatList[0] ;
    //_selectedVal = _commentaireList[0];
    //_SelectedVAL = _ajoutList[0];
  }
  String selectchoice = "rubriques";
  List constatList = [
    "rubriques",
    "Boites aux Lettres",
    "Detecteur de monoxyde de carbon",
    "Decteur de fumée",
  ];
  String selectchoix = "Etat";
  List piece=['Piece','Compteur','Cle'];
  String select="Piece";
  List etatList = [
    "Etat",
    "Bon état",
    "Mauvais état",
    "Neuf",
    "Vétuste",
    "Fonctionne",
    "Ne fonctionne pas",
    "Rénové",
    "Etat d'usage",
  ];
  String selectcommentaire = "Descriptions";
  List commentaireList = [
    "Descriptions",
    "Defauts",
    "Phrases Types",
    "Observations"
  ];
  String p = "Piece";
  String a = "1", b = "3";
  final camera cam = camera();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: Colors.white,
          actions: [
            InkWell(
              child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Icon(
                    Icons.settings,
                    size: 25,
                    color: Colors.black,
                  )),
              onTap: () {},
            )
          ],
          leading: InkWell(
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: const Text(
            "AMEXPERT",
            //textAlign: TextAlign.right,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'FuturaLT.ttf',
                color: Colors.black),
          ),
        ),
        body: ListView(
          children: [
            conteneur(text: "FORMULAIRE DE CONSTAT"),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 15),
              width: MediaQuery.of(context).size.width,
              height: 35,
              decoration: const BoxDecoration(
                color: Color.fromARGB(218, 219, 219, 215),
              ),
              child: Center(
                  child: Text(
                p +
                    " " +
                    globals.getString("nomPiece").toString() +
                    "/" +
                    globals.getString("nomRubriqueConstat").toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "FuturaLT.ttf"),
              )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 15),
              child: DropdownButton(
                value: selectchoice,
                items: constatList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectchoice = val as String;
                  });
                },
                /* icon: const  Icon(
        
      Icons.arrow_drop_down_circle,
   // color: Colors.grey,
  ),*/
                dropdownColor: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButton(
                value: selectchoix,
                items: etatList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (Val) {
                  setState(() {
                    selectchoix = Val as String;
                  });
                },
                /* icon: const  Icon(
        
      Icons.arrow_drop_down_circle,
   // color: Colors.grey,
  ),*/
                dropdownColor: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButton(
                value: selectcommentaire,
                items: commentaireList
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                onChanged: (Val) {
                  setState(() {
                    selectcommentaire = Val as String;
                  });
                },
                /* icon: const  Icon(
        
      Icons.arrow_drop_down_circle,
   // color: Colors.grey,
  ),*/
                dropdownColor: Colors.white,
              ),
            ),
            Conteneur_formulaire(
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Commentaire"),
            Conteneur_formulaire(
                hauteur: MediaQuery.of(context).size.height * 0.2,
                text: "Commentaire Final"),
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                margin: EdgeInsets.only(top: 30, right: 170, left: 170),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(width: 1, color: Colors.black)),
                child: Center(
                    child: camera(),
                  
                  ),
                ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(left: 10, top: 30),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                      child: Text(
                    "ANNULER",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
                onTap: () {},
              ),
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(right: 10, top: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                      child: Text(
                    "ENREGISTRER",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  )),
                ),
                onTap: () {},
              )
            ]),
          ],
        ));
  }
}
