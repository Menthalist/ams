import 'package:ams_mobile/Formulaire_Constat_Cle.dart';
import 'package:ams_mobile/button.dart';
import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/conteneurliste.dart';
import 'package:ams_mobile/conteneurmenu.dart';
import 'package:ams_mobile/listecompteurs.dart';
import 'package:ams_mobile/pdfpreview.dart';
import 'package:ams_mobile/providers/dialogProvider.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Signature.dart';
import 'logement.dart';
import 'piece.dart';
import 'layout/AppLayout.dart';

class listcle extends StatefulWidget {
  const listcle({super.key});

  @override
  State<listcle> createState() => _listcleState();
}

class _listcleState extends State<listcle> {
  late SharedPreferences globals;
  String idEdl = "";
  DialogProvider dialogProvider = DialogProvider();
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  bool signatureVisibility = true;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
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

  List cles = [];
  @override
  Widget build(BuildContext context) {
    Future res = Provider.of<EtatRealisationProvider>(context)
        .getClef(globals.getString("edlId"));
    res.then((value) => cles = value);
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
                context, MaterialPageRoute(builder: (context) => AppLayout()));
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
                      text: "COMPTEURS",
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
          //Padding(padding: EdgeInsets.only()),
          InkWell(
              child: conteneurmenu(
                  go: () {
                    dialogProvider.displayFormKey(idEdl, context);
                    Future res = etatRealisationProvider.getClef(idEdl);
                    res.then((value) {
                      cles = value;
                    });
                  },
                  text1: "CLES",
                  nomb: cles.length.toString(),
                  text2: "AJOUTER")),
          Column(
            children: cles.map((e) {
              Color couleur = Colors.grey;
              String okay = 'Non';
              if (e['constate'] != null) {
                okay = "Oui";
                couleur = Color.fromARGB(255, 104, 245, 111);
              }
              return InkWell(
                onTap: () {
                  globals.setString("nomCles", e['nom'].toString());
                  globals.setString("idKeyNotKey", e['_id'].toString());
                  globals.setString("keyCles", e['key'].toString());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Formulaire_Constat_Cle()));
                },
                child: conteneurliste(
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
                                    composant['type'] = "cles";
                                    etatRealisationProvider
                                        .deleteComposant(composant);
                                    Future res = etatRealisationProvider
                                        .getSpecificEDL(globals
                                            .getString("edlId")
                                            .toString());
                                    res.then((value) {
                                      cles = value;
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
                            ));
                  },
                  piece:
                      // ignore: unnecessary_null_comparison
                      "N° ordre: " + e['num_ordre'].toString() == null
                          ? ""
                          : e['num_ordre'].toString(),
                  nbrecle: e['nom'] == null ? "" : e['nom'].toString(),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
