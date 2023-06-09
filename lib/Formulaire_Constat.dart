import 'dart:core';

import 'dart:io';

import 'package:ams_mobile/Textform_Constat.dart';
import 'package:ams_mobile/camera.dart';
import 'package:ams_mobile/connexion/loginpage.dart';
import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Formulaire_Constat extends StatefulWidget {
  const Formulaire_Constat({Key? key}) : super(key: key);

  @override
  State<Formulaire_Constat> createState() => _Formulaire_ConstatState();
}

class _Formulaire_ConstatState extends State<Formulaire_Constat> {
  late SharedPreferences globals;

  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  String idPiece = "";
  String idEdl = "";
  String idRub = "";
  String etat = "";
  String idRubNotKey = "";
  String description = "";
  String commentaire = "";
  String commentaireFinal = "";
  String Commentairecontrolle = "";
  TextEditingController CommentaireFinalcontroller = TextEditingController();
  String selectchoice = "0";
  dynamic rubrique;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();

    setState(() {
      idPiece = globals.getString("pieceId").toString();
      idEdl = globals.getString("edlId").toString();
      idRub = globals.getString("idRub").toString();
      idRubNotKey = globals.getString("idRubNotKey").toString();
      globals.setString("urlImage1", "");
      globals.setString("urlImage2", "");
      globals.setString("urlImage3", "");
      selectchoice = "0";
    });
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  List constatList = [];
  List commentaires = [
    {"commentaire": " ", "id": "0", "key_": " ", "nature": " ", "type": " "}
  ];

  _Formulaire_ConstatState() {
    //selectchoice = globals.getString("idRub").toString();
  }

  String selectchoix = "Etat";
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
  String selectcommentaireContent = "0";
  List TypecommentaireList = [
    "Description",
    "Defaut",
    "Phrase",
    "Observation",
    "Action",
    "Travail"
  ];
  String p = "Piece";
  String a = "1", b = "3";

  void ClearForm() {
    commentaires = [
      {"commentaire": " ", "id": "0", "key_": " ", "nature": " ", "type": " "}
    ];
    CommentaireFinalcontroller.text = "";
    Commentairecontrolle = "";
    selectchoix = "Etat";
    selectcommentaire = "Description";
    selectcommentaireContent = "0";
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
              idRub = val;
              globals.setString("idRub", val);
              dynamic rubrique =
                  constatList.where((edl) => edl["key"] == idRub).toList()[0];
              if (rubrique['constate'] != null) {
                CommentaireFinalcontroller.text =
                    rubrique['commentaireFinal'].toString();
                Commentairecontrolle = rubrique['commentaire'].toString();
                selectchoix = rubrique['etat'].toString();
                selectcommentaire = rubrique['description'].toString();
              }
              globals.setString("urlImage1", "");
              globals.setString("urlImage2", "");
              globals.setString("urlImage3", "");
              globals.setString(
                  "nomRubriqueConstat", rubrique['nom'].toString());
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
        .getRubriqueOfApiece(globals.getString("edlId").toString(),
            globals.getString("pieceId").toString());
    res.then((value) {
      constatList = value;
      selectchoice = globals.getString("idRub").toString();
      dynamic rubrique =
          constatList.where((edl) => edl["key"] == idRub).toList()[0];
      if (rubrique['constate'] != null) {
        CommentaireFinalcontroller.text =
            rubrique['commentaireFinal'].toString();
        Commentairecontrolle = rubrique['commentaire'].toString();
        if (rubrique['image1'] != null) {
          globals.setString("urlImage1", rubrique['image1'].toString());
        } else {
          globals.setString("urlImage1", "");
        }
        if (rubrique['image2'] != null) {
          globals.setString("urlImage2", rubrique['image2'].toString());
        } else {
          globals.setString("urlImage2", "");
        }
        if (rubrique['image3'] != null) {
          globals.setString("urlImage3", rubrique['image3'].toString());
        } else {
          globals.setString("urlImage3", "");
        }
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
                items: [
                  const DropdownMenuItem(
                      value: "0", child: Text("faite un choix")),
                  ...constatList
                      .map((e) => DropdownMenuItem(
                          value: e["key"], child: Text(e['nom'].toString())))
                      .toList(),
                ],
                onChanged: (val) {
                  setState(() {
                    if (selectcommentaire == "Descriptions" &&
                        selectchoix == 'Etat' &&
                        CommentaireFinalcontroller.text == '' &&
                        Commentairecontrolle == '') {
                      idRub = val as String;
                      globals.setString("idRub", idRub);
                      dynamic rubrique = constatList
                          .where((edl) => edl["key"] == idRub)
                          .toList()[0];
                      globals.setString("nomRubriqueConstat", rubrique['nom']);
                      if (rubrique['constate'] != null) {
                        CommentaireFinalcontroller.text =
                            rubrique['commentaireFinal'].toString();
                        Commentairecontrolle =
                            rubrique['commentaire'].toString();
                      }
                    } else {
                      displayDialogWarning(context, val as String);
                    }
                    selectchoice = val as String;
                  });
                },
                dropdownColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text("Etat"),
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
                    etat = Val as String;
                  });
                },
                dropdownColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text("Types de commentaire"),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButton(
                value: selectcommentaire,
                items: TypecommentaireList.map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    )).toList(),
                onChanged: (Val) {
                  setState(() {
                    selectcommentaire = Val as String;
                    commentaire = Val as String;
                  });

                  Future res = etatRealisationProvider
                      .getCommentairesOfanElement(idRubNotKey, Val.toString());
                  res.then((value) {
                    commentaires = [
                      {
                        "commentaire": " ",
                        "id": "0",
                        "key_": " ",
                        "nature": " ",
                        "type": " "
                      }
                    ];
                    selectcommentaireContent = "0";
                    commentaires.addAll(value);
                    selectcommentaireContent = commentaires[0]['id'];
                    print(commentaires.length);
                  });
                },
                dropdownColor: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Text("Commentaire"),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: DropdownButton(
                value: selectcommentaireContent,
                items: commentaires
                    .map((e) => DropdownMenuItem(
                        value: e["id"], child: Text(e['commentaire'])))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectcommentaireContent = val as String;
                    commentaire = val;
                    dynamic comment = commentaires
                        .where((edl) => edl["id"] == commentaire)
                        .toList()[0];
                    CommentaireFinalcontroller.text = " " +
                        selectcommentaire +
                        ": " +
                        CommentaireFinalcontroller.text +
                        " " +
                        comment["commentaire"];
                  });
                },
                dropdownColor: Colors.white,
              ),
            ),
            Conteneur_formulaire(
                controller: CommentaireFinalcontroller,
                hauteur: MediaQuery.of(context).size.height * 0.10,
                text: "Commentaire Final"),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                margin: EdgeInsets.only(top: 20, right: 10, left: 10),
                width: MediaQuery.of(context).size.width * 0.27,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Center(
                    child: Image(
                  image: FileImage(
                      File(globals.getString("urlImage1").toString())),
                  fit: BoxFit.cover,
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 10, left: 18),
                width: MediaQuery.of(context).size.width * 0.27,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Center(
                    child: Image(
                  image: FileImage(
                      File(globals.getString("urlImage2").toString())),
                  fit: BoxFit.cover,
                )),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, right: 10, left: 18),
                width: MediaQuery.of(context).size.width * 0.27,
                height: MediaQuery.of(context).size.height * 0.12,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1)),
                child: Center(
                    child: Image(
                  image: FileImage(
                      File(globals.getString("urlImage3").toString())),
                  fit: BoxFit.cover,
                )),
              ),
            ]),
            Container(
                height: MediaQuery.of(context).size.height * 0.08,
                margin: EdgeInsets.only(top: 30, right: 170, left: 170),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(120),
                    border: Border.all(width: 1, color: Colors.black)),
                child: Center(child: camera())),
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
                onTap: () async {
                  await etatRealisationProvider.constatRubrique(
                      idEdl,
                      idPiece,
                      idRub,
                      etat,
                      description,
                      Commentairecontrolle,
                      CommentaireFinalcontroller.text,
                      context,
                      globals.getString("urlImage1").toString(),
                      globals.getString("urlImage2").toString(),
                      globals.getString("urlImage3").toString());
                  globals.setString("urlImage1", "");
                  globals.setString("urlImage2", "");
                  globals.setString("urlImage3", "");
                  ClearForm();
                },
              )
            ]),
          ],
        ));
  }
}
