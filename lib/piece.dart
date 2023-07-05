import 'package:ams_mobile/ConteneurPiece.dart';
import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/conteneurmenu.dart';
import 'package:ams_mobile/conteneurrubrique.dart';
import 'package:ams_mobile/layout/AppLayout.dart';
import 'package:ams_mobile/pdfpreview.dart';
import 'package:ams_mobile/providers/dialogProvider.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signature.dart';
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
  DialogProvider dialogProvider = DialogProvider();
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  List pieces = [];
  bool signatureVisibility = true;
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

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    Future res = Provider.of<EtatRealisationProvider>(context)
        .getSpecificEDL(widget.idToEdit);
    res.then((value) => pieces = value);
    Future fini = Provider.of<EtatRealisationProvider>(context)
        .checkEdlConstatEnd(globals.getString("edlId"));
    fini.then((value) => signatureVisibility = value as bool);
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AppLayout()));
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
                      text: "COMPTEURS",
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
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: InkWell(
                    child: button(
                      text: "PDF",
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                      couleur2: Colors.white,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PdfViewerPage()));
                    },
                  ),
                ),
                Visibility(
                    visible: signatureVisibility,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: InkWell(
                        child: button(
                          text: "SIGNATAIRES",
                          couleur1: Color.fromRGBO(17, 45, 194, 0.11),
                          couleur2: Colors.transparent,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signature()));
                        },
                      ),
                    ))
              ]),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.00009,
          ),
          InkWell(
            child: conteneurmenu(
                go: () async {
                  await dialogProvider.displayFormPiece(
                      widget.idToEdit, context);
                  Future res =
                      etatRealisationProvider.getSpecificEDL(widget.idToEdit);
                  res.then((value) {
                    pieces = value;
                  });
                },
                text1: "",
                nomb: "",
                text2: "AJOUTER"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.009,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: pieces.map((e) {
                Color couleur = Colors.grey;
                String okay = 'Non';
                if (e['constate'] == "oui") {
                  okay = "oui";
                  couleur = Color.fromARGB(255, 104, 245, 111);
                }
                return InkWell(
                    child: conteneurrubrique(
                      goDelete: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text("Confirmation suppression"),
                            content: Text(
                                "Voulez vous vraiment supprimer cet élément??"),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  dynamic composant = {};
                                  composant['_id'] = e["_id"];
                                  composant['edl'] = widget.idToEdit;
                                  composant['type'] = "piece";
                                  etatRealisationProvider
                                      .deleteComposant(composant);
                                  Future res = etatRealisationProvider
                                      .getSpecificEDL(widget.idToEdit);
                                  res.then((value) {
                                    pieces = value;
                                  });
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('Continuer'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('Annuler'),
                              ),
                            ],
                          ),
                        );
                      },
                      couleur: couleur,
                      piece: e['nom'] == null ? "" : e["nom"],
                      nbrei: "Rubriques: " + e['rubriques'].toString(),
                      image: Image.asset("assets/img/pie2.png"),
                      nbrem: '',
                      typepi: "Constaté: " + okay.toUpperCase(),
                    ),
                    onTap: () {
                      globals.setString("pieceId", e["key"]);
                      globals.setString(
                          "nomPiece", e["nom"] == null ? "" : e["nom"]);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => rubriqueliste()));
                    });
              }).toList(),
            ),
          ),
        ]));
  }
}
