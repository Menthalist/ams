import 'dart:io';

import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Signature.dart';
import 'Textform_Constat.dart';
import 'camera.dart';
import 'conteneur.dart';

class Formulaire_Constat_compteur extends StatefulWidget {
  const Formulaire_Constat_compteur({super.key});

  @override
  State<Formulaire_Constat_compteur> createState() =>
      _Formulaire_Constat_compteurState();
}

class _Formulaire_Constat_compteurState
    extends State<Formulaire_Constat_compteur> {
  late SharedPreferences globals;

  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  String constate = "ok";
  String idEdl = "";
  String etat = "";
  String description = "";
  String commentaire = "";
  String commentaireFinal = "";
  String idCompteur = "";
  String idCompteurNotKey = "";
  String Commentairecontrolle = "";
  TextEditingController Commentairecontroller = TextEditingController();
  TextEditingController CommentaireFinalcontroller = TextEditingController();
  TextEditingController IndexActuelcontroller = TextEditingController();
  TextEditingController IndexPrecedentcontroller = TextEditingController();
  TextEditingController Anomaliecontroller = TextEditingController();
  String selectcommentaireContent = "0";

  String selectchoice = "0";
  List TypecommentaireList = [
    "Description",
    "Defaut",
    "Phrase",
    "Observation",
    "Action",
    "Travail"
  ];

  List commentaires = [
    {
      "commentaire": "Commentaire ",
      "id": "0",
      "key_": " ",
      "nature": " ",
      "type": " "
    }
  ];
  bool validator = false;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();

    setState(() {
      idEdl = globals.getString("edlId").toString();
      idCompteur = globals.getString("keyCompteur").toString();
      idCompteurNotKey = globals.getString("idCompteurNotKey").toString();
      globals.setString("urlImage1", "");
      globals.setString("urlImage2", "");
      globals.setString("urlImage3", "");
      globals.setString("tempsImage1", "");
      globals.setString("tempsImage2", "");
      globals.setString("tempsImage3", "");
      selectchoice = "0";
      selectchoix = "Etat";
    });
  }

  void ClearForm() {
    CommentaireFinalcontroller.text = "";
    Commentairecontroller.text = "";
    IndexActuelcontroller.text = "";
    IndexPrecedentcontroller.text = "";
    Anomaliecontroller.text = "";
    selectchoix = "Etat";
    selectcommentaire = "Description";
    globals.setString("urlImage1", "");
    globals.setString("urlImage2", "");
    globals.setString("urlImage3", "");
    globals.setString("tempsImage1", "");
    globals.setString("tempsImage2", "");
    globals.setString("tempsImage3", "");
  }

  List constatList = [];
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  _Formulaire_ConstatState() {
    //selectchoice = globals.getString("idRub").toString();
  }

  String selectchoix = "Etat";
  List piece = ['Piece', 'Compteur', 'Cle'];
  String select = "Piece";
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
  String selectcommentaire = "Description";
  List commentaireList = [
    "Description",
    "Defaut",
    "Phrase",
    "Observation",
    "Action",
    "Travail"
  ];
  String p = "Compteur";
  String a = "1", b = "3";

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
              globals.setString("urlImage1", "");
              globals.setString("tempsImage1", "");
            }
            if (idTof == 2) {
              globals.setString("tempsImage2", "");
              globals.setString("urlImage2", "");
            }
            if (idTof == 3) {
              globals.setString("urlImage3", "");
              globals.setString("tempsImage3", "");
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

  ShowDialogWarningIndex(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Text("Problème avec les indexes"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  ShowDialogWarningField(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Text("Attention tous les champs sont obligatoires"),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  void configForm(dynamic compteur_) {
    CommentaireFinalcontroller.text = compteur_['commentaireFinal'].toString();
    IndexActuelcontroller.text = compteur_['indexActuel'].toString();
    IndexPrecedentcontroller.text = compteur_['indexPrecedent'].toString();
    Anomaliecontroller.text = compteur_['anomalie'].toString();
    Commentairecontrolle = compteur_['commentaire'].toString();
    selectchoix = compteur_['etat'].toString() == ""
        ? "Etat"
        : compteur_['etat'].toString();

    if (compteur_['image1'] != null) {
      File file = File(compteur_['image1'].toString());
      if (file.existsSync()) {
        globals.setString("urlImage1", compteur_['image1'].toString());
        globals.setString("tempsImage1", compteur_['tempsImage1'].toString());
      } else {
        if (globals.getString("urlImage1").toString() == "") {
          globals.setString("urlImage1", "");
          globals.setString("tempsImage1", "");
        }
      }
    } else {
      if (globals.getString("urlImage1").toString() == "") {
        globals.setString("urlImage1", "");
        globals.setString("tempsImage1", "");
      }
    }

    if (compteur_['image2'] != null) {
      File file = File(compteur_['image2'].toString());
      if (file.existsSync()) {
        globals.setString("urlImage2", compteur_['image2'].toString());
        globals.setString("tempsImage2", compteur_['tempsImage2'].toString());
      } else {
        if (globals.getString("urlImage2").toString() == "") {
          globals.setString("urlImage2", "");
          globals.setString("tempsImage2", "");
        }
      }
    } else {
      if (globals.getString("urlImage2").toString() == "") {
        globals.setString("urlImage2", "");
        globals.setString("tempsImage2", "");
      }
    }

    if (compteur_['image3'] != null) {
      File file = File(compteur_['image3'].toString());
      if (file.existsSync()) {
        globals.setString("urlImage3", compteur_['image3'].toString());
        globals.setString("tempsImage3", compteur_['tempsImage3'].toString());
      } else {
        if (globals.getString("urlImage3").toString() == "") {
          globals.setString("urlImage3", "");
          globals.setString("tempsImage3", "");
        }
      }
    } else {
      if (globals.getString("urlImage3").toString() == "") {
        globals.setString("urlImage3", "");
        globals.setString("tempsImage3", "");
      }
    }
  }

  void displayDialogWarning(BuildContext context_, String val,
      {String text =
          "Attention les données en cours de saisie seront perdues car vous ne les avez pas encore enregistrés. Confirmez-vous cette opération??",
      String titre = "Voulez vous annuler le constat en cours??"}) {
    Text message = Text(text);
    Text title = Text(titre);
    // show the dialog
    showDialog(
      context: context_,
      builder: (BuildContext context) => AlertDialog(
        title: title,
        content: message,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              ClearForm();
              idCompteur = val;
              globals.setString("keyCompteur", val);
              dynamic compteur_ = constatList
                  .where((compteur) => compteur["key"] == idCompteur)
                  .toList()[0];
              if (compteur_['constate'] != null) {
                configForm(compteur_);
              } else {
                /**/
              }
              globals.setString("nomCompteur", compteur_['nom'].toString());
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
  }

  @override
  Widget build(BuildContext context) {
    Future res = Provider.of<EtatRealisationProvider>(context)
        .getCompteur(globals.getString("edlId").toString());

    res.then((value) {
      constatList = value;
      selectchoice = globals.getString("keyCompteur").toString();
      dynamic compteur_ = constatList
          .where((compteur) =>
              compteur["key"] == globals.getString("keyCompteur").toString())
          .toList()[0];
      if (compteur_['constate'] != null) {
        configForm(compteur_);
      } else {
        /**/
      }
    });
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
                p + "/" + globals.getString("nomCompteur").toString(),
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
                items: [
                  const DropdownMenuItem(
                      value: "0", child: Text("faite un choix")),
                  ...constatList.map((e) {
                    Color? couleur = Colors.black;
                    if (e['constate'] != null) {
                      couleur = Colors.green[400];
                    }
                    return DropdownMenuItem(
                      value: e['key'],
                      child: Text(
                        e['nom'].toString(),
                        style: TextStyle(color: couleur),
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (val) {
                  displayDialogWarning(context, val as String);
                  setState(() {
                    /*if (selectcommentaire == "Description" &&
                        selectchoix == 'Etat' &&
                        CommentaireFinalcontroller.text == '' &&
                        Anomaliecontroller.text == '' &&
                        IndexActuelcontroller.text == '' &&
                        IndexPrecedentcontroller.text == '') {
                      idCompteur = val as String;
                      dynamic compteur_ = constatList
                          .where((compteur) => compteur["key"] == idCompteur)
                          .toList()[0];
                      globals.setString("idCompteur", idCompteur);
                      globals.setString("nomCompteur", compteur_['nom']);
                    } else {
                      
                    }*/
                    selectchoice = val as String;
                  });
                },
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
                    etat = Val;
                  });
                },
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
                    commentaire = Val;
                  });

                  Future res =
                      etatRealisationProvider.getCommentairesOfanElement(
                          idCompteurNotKey, Val.toString());
                  res.then((value) {
                    commentaires = [
                      {
                        "commentaire": "Commentaire",
                        "id": "0",
                        "key_": " ",
                        "nature": " ",
                        "type": " "
                      }
                    ];
                    selectcommentaireContent = "0";
                    commentaires.addAll(value);
                    selectcommentaireContent = commentaires[0]['id'];
                  });
                },
                dropdownColor: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButton(
                value: selectcommentaireContent,
                items: commentaires.map((e) {
                  return DropdownMenuItem(
                      value: e["id"], child: Text(e['commentaire']));
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectcommentaireContent = val as String;
                    commentaire = val;
                    dynamic comment = commentaires
                        .where((edl) => edl["id"] == commentaire)
                        .toList()[0];
                    CommentaireFinalcontroller.text = "\n" +
                        selectcommentaire +
                        ": " +
                        comment["commentaire"] +
                        " " +
                        CommentaireFinalcontroller.text;
                  });
                },
                dropdownColor: Colors.white,
              ),
            ),
            Conteneur_formulaire(
                type: TextInputType.number,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Index Actuel",
                controller: IndexActuelcontroller),
            Conteneur_formulaire(
                type: TextInputType.number,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Index Precedent ",
                controller: IndexPrecedentcontroller),
            Conteneur_formulaire(
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Anomalie Compteur ",
                controller: Anomaliecontroller),
            Conteneur_formulaire(
                maxLines: 10,
                controller: CommentaireFinalcontroller,
                hauteur: MediaQuery.of(context).size.height * 0.08,
                text: "Commentaire Final"),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                onTap: () {
                  ShowDialogwidget(
                      context, globals.getString("urlImage1").toString(), 1);
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: Center(
                          child: Image(
                        image: FileImage(
                            File(globals.getString("urlImage1").toString())),
                        fit: BoxFit.cover,
                      )),
                    ),
                    Text("   " + globals.getString("tempsImage1").toString(),
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ShowDialogwidget(
                      context, globals.getString("urlImage2").toString(), 2);
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 10, left: 18),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: Center(
                          child: Image(
                        image: FileImage(
                            File(globals.getString("urlImage2").toString())),
                        fit: BoxFit.cover,
                      )),
                    ),
                    Text("   " + globals.getString("tempsImage2").toString(),
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  ShowDialogwidget(
                      context, globals.getString("urlImage3").toString(), 3);
                },
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, right: 10, left: 18),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: Center(
                          child: Image(
                        image: FileImage(
                            File(globals.getString("urlImage3").toString())),
                        fit: BoxFit.cover,
                      )),
                    ),
                    Text("   " + globals.getString("tempsImage3").toString(),
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              camera(cas: "compteur"),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.25,
                  margin: EdgeInsets.only(left: 10, top: 30),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Signature()));
                },
              ),
              InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.25,
                  margin: EdgeInsets.only(right: 10, top: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
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
                onTap: () {
                  if (CommentaireFinalcontroller.text.isEmpty ||
                      IndexActuelcontroller.text.isEmpty ||
                      IndexPrecedentcontroller.text.isEmpty ||
                      IndexActuelcontroller.text.isEmpty ||
                      IndexPrecedentcontroller.text.isEmpty) {
                    ShowDialogWarningField(context);
                    return;
                  }
                  if (int.parse(IndexActuelcontroller.text) <
                      int.parse(IndexPrecedentcontroller.text)) {
                    ShowDialogWarningIndex(context);
                    return;
                  }

                  etatRealisationProvider.constatCompteur(
                      idEdl,
                      idCompteur,
                      etat,
                      IndexActuelcontroller.text,
                      IndexPrecedentcontroller.text,
                      Anomaliecontroller.text,
                      CommentaireFinalcontroller.text,
                      Commentairecontroller.text,
                      description,
                      context,
                      globals.getString("urlImage1").toString(),
                      globals.getString("urlImage2").toString(),
                      globals.getString("urlImage3").toString(),
                      globals.getString("tempsImage1").toString(),
                      globals.getString("tempsImage2").toString(),
                      globals.getString("tempsImage3").toString());
                  ClearForm();
                },
              )
            ]),
          ],
        ));
  }
}
