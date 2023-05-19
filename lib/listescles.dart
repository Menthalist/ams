import 'package:ams_mobile/CustumBottomNavigation.dart';
import 'package:ams_mobile/button.dart';
import 'package:ams_mobile/clelist.dart';
import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/conteneurliste.dart';
import 'package:ams_mobile/conteneurmenu.dart';
import 'package:ams_mobile/listecompteurs.dart';
import 'package:ams_mobile/layout/AppLayout.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logement.dart';
import 'piece.dart';

class listcle extends StatefulWidget {
  const listcle({super.key});

  @override
  State<listcle> createState() => _listcleState();
}

class _listcleState extends State<listcle> {
  late SharedPreferences globals;
  String idRub = "";

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

  List cles = [];
  @override
  Widget build(BuildContext context) {
    cles = Provider.of<EtatRealisationProvider>(context).getClef(idRub);
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
            onTap: () {
               // Navigator.push(
                //context, MaterialPageRoute(builder: (context) => CustomBottomNavigation()));
            },
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
      
      body: ListView(
        children: [
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
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.transparent,
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
                      couleur1: Colors.white,
                      couleur2: Colors.black,
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
                text1: "CLES", nomb: cles.length.toString(), text2: "AJOUTER"),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text(
                          "AJOUTER UNE CLE ",
                          style: TextStyle(
                              fontFamily: "futura.LT",
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                          textAlign: TextAlign.left,
                        ),
                        content: SingleChildScrollView(
                            child: ListBody(children: [
                          Container(
                              margin: EdgeInsets.only(left: 11),
                              child: Text(
                                "CLE",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.08,
                            margin: EdgeInsets.only(
                              left: 3,
                              right: 3,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1.0,
                                  color: Color.fromARGB(218, 219, 219, 215)),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Salon Principal",
                                  contentPadding: EdgeInsets.only(
                                    left: 9,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 11),
                              child: Text(
                                "NOMBRE",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.08,
                            margin: EdgeInsets.only(
                              left: 5,
                              right: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1.0,
                                  color: Color.fromARGB(218, 219, 219, 215)),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "2",
                                contentPadding: EdgeInsets.only(
                                  left: 9,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 11),
                              child: Text(
                                "ETAT",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.08,
                            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1.0,
                                  color: Color.fromARGB(218, 219, 219, 215)),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "CLE NEUVE",
                                contentPadding: EdgeInsets.only(
                                  left: 9,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(left: 11),
                              child: Text(
                                "COMMENTAIRE",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900),
                              )),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.08,
                            width: MediaQuery.of(context).size.width * 0.28,
                            margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  width: 1.0,
                                  color: Color.fromARGB(218, 219, 219, 215)),
                            ),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Clé du Salon Principal",
                                contentPadding: EdgeInsets.only(
                                  left: 9,
                                ),
                                hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                          InkWell(
                            child: Container(
                              margin:
                                  EdgeInsets.only(left: 5, right: 5, top: 10),
                              height: MediaQuery.of(context).size.height * 0.04,
                              width: MediaQuery.of(context).size.width * 0.08,
                              decoration: BoxDecoration(
                                color: Color(0xFF333333),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "ENREGISTRER",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                            ),
                            onTap: () {
                              // Navigator.push(
                              //     context, MaterialPageRoute(builder: (context) => home()));
                            },
                          ),
                        ])),
                      ));
            },
          ),
          Column(
            children: cles.map((e) {
              return conteneurliste(
                piece: "N° ordre: " + e['num_ordre'],
                nbrecle: e['nom'],
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
