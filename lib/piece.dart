import 'package:ams_mobile/ConteneurPiece.dart';
import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/conteneurmenu.dart';
import 'package:ams_mobile/conteneurrubrique.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'button.dart';
import 'listecompteurs.dart';
import 'listescles.dart';
import 'logement.dart';

class piececonteneur extends StatefulWidget {
  String idToEdit;

  piececonteneur({Key? key, required this.idToEdit}) : super(key: key);

  @override
  State<piececonteneur> createState() => _piececonteneurState();
}

class _piececonteneurState extends State<piececonteneur> {
  late SharedPreferences globals;
  bool? check1 = false;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      var id = globals.getString("edlId");
      if (id != null) {
        widget.idToEdit = id;
      }
    });
  }

  List pieces = [];
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    pieces = Provider.of<EtatRealisationProvider>(context)
        .getSpecificEDL(widget.idToEdit);
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
                      couleur1: Colors.white,
                      couleur2: Colors.black,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => piececonteneur(
                                    idToEdit: widget.idToEdit,
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
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.white,
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.00009,
          ),
         Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(right: 10),
      height: MediaQuery.of(context).size.height * 0.03,
      color: Color.fromRGBO(174, 184, 234, 0.19),
      child: InkWell(
        child: Align(
          alignment: Alignment.centerRight,
          child:Text("Ajouter",style: TextStyle(fontFamily: 'Futura.LT',fontSize: 18,fontWeight: FontWeight.w700),)),
      onTap: () {
        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => rubriqueliste())
                              );
                         showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text(
                          "AJOUTER UNE PIECE ",
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
                                "NOM",
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
                                  hintText: "Nom",
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
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.08,
                            margin: EdgeInsets.only(
                              left: 3,
                              right: 3,
                              top: 10,
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
                                  hintText: "Description",
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
      ),
     
        
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.009,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: pieces.map((e) {
                return InkWell(
                    child: conteneurrubrique(
                      piece: e['nom'],
                      nbrei: "N° ordre: ",
                      image: Image.asset("assets/img/pie2.png"),
                      nbrem: e['num_ordre'],
                      typepi: e['etat'],
                    ),
                    onTap: () {
                      globals.setString("pieceId", e["_id"]);
                      globals.setString("nomPiece", e["nom"]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => rubriqueliste())
                              );
                    });
              }).toList(),
            ),
          ),
        ]));
  }
}
