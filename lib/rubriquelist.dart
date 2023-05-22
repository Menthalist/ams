import 'dart:math';

import 'package:ams_mobile/conteneurrubrique.dart';
import 'package:ams_mobile/list_rubrique.dart';
import 'package:ams_mobile/listescles.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Formulaire_Constat.dart';
import 'button.dart';
import 'conteneur.dart';
import 'conteneurmenu.dart';
import 'listecompteurs.dart';
import 'logement.dart';
import 'piece.dart';

class rubriqueliste extends StatefulWidget {
  const rubriqueliste({
    super.key,
  });
  @override
  State<rubriqueliste> createState() => _rubriquelisteState();
}

class _rubriquelisteState extends State<rubriqueliste> {
  late SharedPreferences globals;
  String idPiece = "";

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      var id = globals.getString("pieceId");
      if (id != null) {
        idPiece = id;
      }
    });
  }

  List rubriques = [];
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    rubriques = Provider.of<EtatRealisationProvider>(context)
        .getRubriqueOfApiece(idPiece);
    String titre = rubriques.length.toString() + "  Rubriques";
    return Scaffold(
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
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
        body: ListView(children: [
          conteneur(text: "CONSTAT D'ETAT DE LIEU"),
          Container(
            height: MediaQuery.of(context).size.height * 0.055,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 2),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Padding(
                  padding: EdgeInsets.only(left: 7),
                  child: InkWell(
                    child: button(
                      text: "LOGEMENT",
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.transparent,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Logement()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: button(
                      text: "PIECES",
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.transparent,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => piececonteneur(
                                    idToEdit: "",
                                  )));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: button(
                      text: "RUBRIQUES",
                      couleur1: Colors.white,
                      couleur2: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => rubriqueliste()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: button(
                      text: "CLES",
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.transparent,
                    ),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => listcle()));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: button(
                      text: "COMPTEUR",
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.transparent,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => listecompteur()));
                    },
                  ),
                )
              ]),
            ),
          ),
          //Padding(padding: EdgeInsets.only()),
          InkWell(
            child: conteneurmenu(
                text1: titre,
                nomb: globals.getString("nomPiece").toString(),
                text2: "AJOUTER"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: rubriques.map((e) {
                return InkWell(
                  child: conteneurrubrique(
                      piece: e['nom'] == null ? e['nom'] : "",
                      nbrei: "total",
                      nbrem: "1",
                      typepi: e['etat'] == null ? e['etat'] : "",
                      image: Image.asset("assets/img/rect.png")),
                  onTap: () {
                    globals.setString("nomRubriqueConstat", e['nom']);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Formulaire_Constat()));
                  },
                );
              }).toList(),
            ),
          ),
        ]));
  }
}
