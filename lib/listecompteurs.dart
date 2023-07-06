import 'package:ams_mobile/Formulaire_Constat_Compteur.dart';
import 'package:ams_mobile/conteneurcompteur.dart';
import 'package:ams_mobile/listescles.dart';
import 'package:ams_mobile/pdfpreview.dart';
import 'package:ams_mobile/piece.dart';
import 'package:ams_mobile/providers/dialogProvider.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signature.dart';
import 'button.dart';
import 'conteneur.dart';
import 'conteneurmenu.dart';
import 'layout/AppLayout.dart';
import 'logement.dart';

class listecompteur extends StatefulWidget {
  const listecompteur({super.key});

  @override
  State<listecompteur> createState() => _listecompteurState();
}

class _listecompteurState extends State<listecompteur> {
  late SharedPreferences globals;
  String idEdl = "";
  DialogProvider dialogProvider = DialogProvider();
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  bool signatureVisibility = true;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      globals.setString("nomCompteur", "");
      globals.setString("idCompteurNotKey", "");
      globals.setString("keyCompteur", "");
      var id = globals.getString("edlId");
      if (id != null) {
        idEdl = id;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  ShowDialogwidget(BuildContext context, String path, int idTof) {
    AlertDialog alert = AlertDialog(
      content: Text("Voulez vous vraiment supprimer cette photo?"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("NON"),
        ),
        TextButton(
          onPressed: () {
            etatRealisationProvider.deleteFile(path);
            if (idTof == 1) {
              globals.setString("urlImage1clef", "");
              globals.setString("tempsImage1clef", "");
            }
            if (idTof == 2) {
              globals.setString("tempsImage2clefclef", "");
              globals.setString("urlImage2", "");
            }
            if (idTof == 3) {
              globals.setString("urlImage3clef", "");
              globals.setString("tempsImage3clef", "");
            }
            Navigator.pop(context);
          },
          child: Text("OUI"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  List compteurs = [];
  @override
  Widget build(BuildContext context) {
    Future rest = Provider.of<EtatRealisationProvider>(context)
        .getCompteur(globals.getString("edlId").toString());
    rest.then((value) => compteurs = value);
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
                      text: "COMPTEURS",
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: conteneurmenu(
                go: () async {
                  dialogProvider.displayDialogCompteur(idEdl, context);
                  Future res = etatRealisationProvider.getCompteur(idEdl);
                  res.then((value) {
                    compteurs = value;
                  });
                },
                text1: "COMPTEURS",
                nomb: compteurs.length.toString(),
                text2: "AJOUTER"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: compteurs.map((e) {
                Color couleur = Colors.grey;
                String okay = 'Non';
                if (e['constate'] != null) {
                  okay = "Oui";
                  couleur = Color.fromARGB(255, 104, 245, 111);
                }
                return InkWell(
                  onTap: () {
                    globals.setString("nomCompteur", e['nom'].toString());
                    globals.setString("idCompteurNotKey", e['_id'].toString());
                    globals.setString("keyCompteur", e['key'].toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Formulaire_Constat_compteur()));
                  },
                  child: conteneurcompteur(
                    couleur: couleur,
                    onDelete: () {
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
                                composant['edl'] =
                                    globals.getString("edlId").toString();
                                composant['type'] = "compteur";
                                etatRealisationProvider
                                    .deleteComposant(composant);
                                Future res =
                                    etatRealisationProvider.getSpecificEDL(
                                        globals.getString("edlId").toString());
                                res.then((value) {
                                  compteurs = value;
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
                    compteur: e['nom'].toString(),
                    consom: "N° ordre: " + e['num_ordre'].toString(),
                  ),
                );
              }).toList(),
            ),
          ),
        ]));
  }
}
