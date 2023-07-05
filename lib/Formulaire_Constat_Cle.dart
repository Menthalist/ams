import 'dart:io';

import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Textform_Constat.dart';
import 'camera.dart';
import 'conteneur.dart';

class Formulaire_Constat_Cle extends StatefulWidget {
  @override
  State<Formulaire_Constat_Cle> createState() => _Formulaire_Constat_CleState();
}

class _Formulaire_Constat_CleState extends State<Formulaire_Constat_Cle> {
  late SharedPreferences globals;

  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  String constate = "ok";
  String idPiece = "";
  String idEdl = "";
  String idKey = "";
  String etat = "";
  String description = "";
  String commentaire = "";
  String commentaireFinal = "";
  String idRubNotKey = "";
  String Commentairecontrolle = "";
  TextEditingController Commentairecontroller = TextEditingController();
  TextEditingController CommentaireFinalcontroller = TextEditingController();
  TextEditingController remisecontroller = TextEditingController();
  TextEditingController renduscontroller = TextEditingController();
  TextEditingController nbrefacturecontroller = TextEditingController();
  TextEditingController motiffactutationcontroller = TextEditingController();
  TextEditingController prixttccontroller = TextEditingController();
  String selectcommentaireContent = "0";
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

  String selectchoice = "0";
  bool validator = false;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();

    setState(() {
      idPiece = globals.getString("pieceId").toString();
      idEdl = globals.getString("edlId").toString();
      idKey = globals.getString("keyCles").toString();
      idRubNotKey = globals.getString("idKeyNotKey").toString();
      globals.setString("urlImage1", "");
      globals.setString("urlImage2", "");
      globals.setString("urlImage3", "");
      globals.setString("tempsImage1", "");
      globals.setString("tempsImage2", "");
      globals.setString("tempsImage3", "");
      selectchoice = "0";
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

  void ClearForm() {
    CommentaireFinalcontroller.text = "";
    remisecontroller.text = "";
    Commentairecontrolle = "";
    renduscontroller.text = "";
    nbrefacturecontroller.text = "";
    motiffactutationcontroller.text = "";
    prixttccontroller.text = "";
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
  String p = "Clés";
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
              globals.setString("tempsImage3", "");
              globals.setString("urlImage3", "");
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

  void configForm(dynamic clef_) {
    CommentaireFinalcontroller.text = clef_['commentaireFinal'].toString();
    remisecontroller.text = clef_['remise'].toString();
    renduscontroller.text = clef_['rendus'].toString();
    nbrefacturecontroller.text = clef_['nombreFacture'].toString();
    motiffactutationcontroller.text = clef_['motif_facturation'].toString();
    prixttccontroller.text = clef_['prix_ttc'].toString();
    Commentairecontrolle = clef_['commentaire'].toString();

    if (clef_['image1'] != null || clef_['image1'] != "") {
      File file = File(clef_['image1'].toString());
      if (file.existsSync()) {
        globals.setString("urlImage1", clef_['image1'].toString());
        globals.setString("tempsImage1", clef_['tempsImage1'].toString());
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

    if (clef_['image2'] != null || clef_['image2'] != "") {
      File file = File(clef_['image2'].toString());
      if (file.existsSync()) {
        globals.setString("urlImage2", clef_['image2'].toString());
        globals.setString("tempsImage2", clef_['tempsImage2'].toString());
      } else {
        if (globals.getString("urlImage2").toString() == "") {
          globals.setString("urlImage2", "");
          globals.setString("tempsImage2", "");
        }
      }
    } else {
      if (globals.getString("urlImage2").toString() == "") {
        globals.setString("urlImage2", "");
        globals.setString("tempsImage2clef", "");
      }
    }

    if (clef_['image3'] != null || clef_['image3'] != "") {
      File file = File(clef_['image3'].toString());
      if (file.existsSync()) {
        globals.setString("urlImage3", clef_['image3'].toString());
        globals.setString("tempsImage3", clef_['tempsImage3'].toString());
      } else {
        if (globals.getString("urlImage3").toString() == "") {
          globals.setString("urlImage3", "");
          globals.setString("tempsImage3", "");
        }
      }
    } else {
      if (globals.getString("urlImage3").toString() == "") {
        globals.setString("urlImage3", "");
        globals.setString("urlImage3", "");
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
              idKey = val;
              globals.setString("keyCles", val);
              dynamic clef_ =
                  constatList.where((cle) => cle["key"] == idKey).toList()[0];
              if (clef_['constate'] != null) {
                configForm(clef_);
              } else {
                /**/
              }
              globals.setString("nomCles", clef_['nom'].toString());
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
        .getClef(globals.getString("edlId").toString());
    res.then((value) {
      constatList = value;
      selectchoice = globals.getString("keyCles").toString();
      dynamic clef_ =
          constatList.where((clef) => clef["key"] == idKey).toList()[0];
      if (clef_['constate'] != null) {
        configForm(clef_);
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
                "Cles: " + globals.getString("nomCles").toString(),
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
                      value: e["key"],
                      child: Text(e['nom'].toString(),
                          style: TextStyle(color: couleur)),
                    );
                  }).toList(),
                ],
                onChanged: (val) {
                  displayDialogWarning(context, val as String);
                  setState(() {
                    /*if (selectcommentaire == "Description" &&
                        selectchoix == 'Etat' &&
                        CommentaireFinalcontroller.text == '' &&
                        Commentairecontroller.text == '') {
                      idKey = val as String;
                      dynamic clef_ = constatList
                          .where((clef) => clef["key"] == idKey)
                          .toList()[0];
                      globals.setString("keyCles", idKey);
                      globals.setString("nomCles", clef_['nom']);
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

                  Future res = etatRealisationProvider
                      .getCommentairesOfanElement(idRubNotKey, Val.toString());
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
                onChanged: (val) async {
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
                maxLines: 10,
                type: TextInputType.number,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Nombre de remise",
                controller: remisecontroller),
            Conteneur_formulaire(
                type: TextInputType.number,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Nombre de rendus",
                controller: renduscontroller),
            Conteneur_formulaire(
                type: TextInputType.number,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Nombre de facturé",
                controller: nbrefacturecontroller),
            Conteneur_formulaire(
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Motifs de non facturation",
                controller: motiffactutationcontroller),
            Conteneur_formulaire(
                type: TextInputType.number,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Prix TTC",
                controller: prixttccontroller),
            Conteneur_formulaire(
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
              camera(cas: "clef"),
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
                  Navigator.pop(context);
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
                onTap: () async {
                  if (CommentaireFinalcontroller.text.isEmpty ||
                      remisecontroller.text.isEmpty ||
                      renduscontroller.text.isEmpty ||
                      nbrefacturecontroller.text.isEmpty ||
                      prixttccontroller.text.isEmpty) {
                    ShowDialogWarningField(context);
                    return;
                  }

                  await etatRealisationProvider.constatClef(
                      idEdl,
                      idKey,
                      etat,
                      remisecontroller.text,
                      renduscontroller.text,
                      nbrefacturecontroller.text,
                      motiffactutationcontroller.text,
                      prixttccontroller.text,
                      description,
                      commentaire,
                      CommentaireFinalcontroller.text,
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
