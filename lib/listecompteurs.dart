import 'package:ams_mobile/Formulaire_Constat_Compteur.dart';
import 'package:ams_mobile/conteneurcompteur.dart';
import 'package:ams_mobile/listescles.dart';
import 'package:ams_mobile/piece.dart';
import 'package:ams_mobile/providers/dialogProvider.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'button.dart';
import 'conteneur.dart';
import 'conteneurmenu.dart';

class listecompteur extends StatefulWidget {
  const listecompteur({super.key});

  @override
  State<listecompteur> createState() => _listecompteurState();
}

class _listecompteurState extends State<listecompteur> {
  late SharedPreferences globals;
  String idRub = "";
  DialogProvider dialogProvider = DialogProvider();

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      var id = globals.getString("edlId");
      if (id != null) {
        idRub = id;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  List compteurs = [];
  @override
  Widget build(BuildContext context) {
    compteurs =
        Provider.of<EtatRealisationProvider>(context).getCompteur(idRub);
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
                    onTap: () {},
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
                          couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                          couleur2: Colors.transparent,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => rubriqueliste()));
                        })),
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
                      couleur1: Colors.white,
                      couleur2: Colors.black,
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: conteneurmenu(
                go: () {
                  dialogProvider.displayDialogCompteur(context); 
                },
                  text1: "COMPTEURS",
                  nomb: compteurs.length.toString(),
                  text2: "AJOUTER"),
              
            
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: InkWell(
              onTap: (){
                 Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Formulaire_Constat_compteur()));
              },
              child: Column(
                children: compteurs.map((e) {
                  return conteneurcompteur(
                    compteur: e['nom'] == null ? "" : e['nom'],
                    // ignore: unnecessary_null_comparison
                    consom: "N° ordre: " + e['num_ordre'] == null
                        ? e["num_ordre"]
                        : "",
                  );
                }).toList(),
              ),
            ),
          ),
        ]));
  }
}
