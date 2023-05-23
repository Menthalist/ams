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
  String description = "";
  String commentaire = "";
  String commentaireFinal = "";
  TextEditingController Commentairecontrolle = TextEditingController();
  TextEditingController CommentaireFinalcontroller = TextEditingController();
  String selectchoice = "0";

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();

    setState(() {
      idPiece = globals.getString("pieceId").toString();
      idEdl = globals.getString("edlId").toString();
      idRub = globals.getString("idRub").toString();
      selectchoice = globals.getString("idRub").toString();
    });
  }

  void ClearForm() {
    CommentaireFinalcontroller.text = "";
    Commentairecontrolle.text = "";
    selectchoix = "Etat";
    selectcommentaire = "Descriptions";
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
  String selectcommentaire = "Descriptions";
  List commentaireList = [
    "Descriptions",
    "Defauts",
    "Phrases Types",
    "Observations"
  ];
  String p = "Piece";
  String a = "1", b = "3";

  void displayDialogWarning(BuildContext context_,
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
    constatList = Provider.of<EtatRealisationProvider>(context)
        .getRubriqueOfApiece(idPiece);
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
                          value: e["value"], child: Text(e['nom'])))
                      .toList(),
                ],
                onChanged: (val) {
                  setState(() {
                    if (selectcommentaire == "Descriptions" &&
                        selectchoix == 'Etat' &&
                        CommentaireFinalcontroller.text == '' &&
                        Commentairecontrolle.text == '') {
                      idRub = val as String;
                      globals.setString("idRub", idRub);
                      globals.setString("nomRubriqueConstat", "test");
                    } else {
                      displayDialogWarning(context);
                    }
                    selectchoice = val as String;
                  });
                },
                /* icon: const  Icon(
        
      Icons.arrow_drop_down_circle,
   // color: Colors.grey,
  ),*/
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
                    etat = Val as String;
                  });
                },
                /* icon: const  Icon(
        
      Icons.arrow_drop_down_circle,
   // color: Colors.grey,
  ),*/
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
                    commentaire = Val as String;
                  });
                },
                /* icon: const  Icon(
        
      Icons.arrow_drop_down_circle,
   // color: Colors.grey,
  ),*/
                dropdownColor: Colors.white,
              ),
            ),
            Conteneur_formulaire(
                controller: Commentairecontrolle,
                hauteur: MediaQuery.of(context).size.height * 0.06,
                text: "Commentaire"),
            Conteneur_formulaire(
                controller: CommentaireFinalcontroller,
                hauteur: MediaQuery.of(context).size.height * 0.2,
                text: "Commentaire Final"),
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
                onTap: () {
                  etatRealisationProvider.constatRubrique(
                      idEdl,
                      idPiece,
                      idRub,
                      etat,
                      description,
                      Commentairecontrolle.text,
                      CommentaireFinalcontroller.text,
                      context);
                  ClearForm();
                },
              )
            ]),
          ],
        ));
  }
}
