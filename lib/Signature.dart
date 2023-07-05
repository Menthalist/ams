import 'dart:typed_data';
import 'package:ams_mobile/conteneurmenu.dart';
import 'package:ams_mobile/pdfpreview.dart';
import 'package:ams_mobile/piece.dart';
import 'package:ams_mobile/providers/dialogProvider.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutter_signature_view/flutter_signature_view.dart';
import 'SignaturePad.dart';
import 'button.dart';
import 'conteneur.dart';
import 'listecompteurs.dart';
import 'listescles.dart';
import 'logement.dart';
import 'package:signature/signature.dart';

class Signature extends StatefulWidget {
  // const Signature({super.key, SignatureController? controller});

  @override
  State<Signature> createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  late SharedPreferences globals;
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  DialogProvider dialogProvider = DialogProvider();
  String idEdl = "";
//  Uint8List? exportedImage;
  //late  SignatureController _controller ;
  /* final SignatureController _controller = SignatureController(
    penStrokeWidth: 5.0,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );*/

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();

    setState(() {
      idEdl = globals.getString("edlId").toString();
      Future edl = etatRealisationProvider.getSingleEdl(idEdl);
      edl.then((value) =>
          globals.setString("idClient", value['logement']['client']['_id']));
    });
  }

  List<dynamic> signataires = [];
  bool signatureVisibility = false;
  List<dynamic> listeSignataireToAdd = [];
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  //participant dialog

  void displayFormSignataire(
      String idEdl, BuildContext context_, List signatairesList,
      {String text = "", String titre = ""}) {
    Text message = Text(text);
    Text title = Text(titre);
    TextEditingController nom = TextEditingController();
    TextEditingController description = TextEditingController();
    TextEditingController role = TextEditingController();
    dynamic signataire = {};
    String selectchoice = "0";
    String messageErreur = "";
    // show the dialog
    showDialog(
        context: context_,
        builder: (ctx) => AlertDialog(
              title: Text(
                "AJOUTER UN SIGNATAIRE ",
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
                      messageErreur,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    )),
                Container(
                    margin: EdgeInsets.only(left: 11),
                    child: Text(
                      "Liste Signataire",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    )),
                Container(
                  height: MediaQuery.of(context_).size.height * 0.05,
                  width: MediaQuery.of(context_).size.width * 0.08,
                  margin: EdgeInsets.only(
                    left: 3,
                    right: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        width: 1.0, color: Color.fromARGB(218, 219, 219, 215)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: DropdownButton(
                      value: selectchoice,
                      items: [
                        const DropdownMenuItem(
                            value: "0", child: Text("faite un choix")),
                        ...signatairesList.map((e) {
                          return DropdownMenuItem(
                              value: e["id"], child: Text(e['nom'].toString()));
                        }).toList()
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectchoice = val as String;
                          signataire = signatairesList
                              .where((signa) => signa["id"] == val)
                              .toList()[0];
                          nom.text = signataire['nom'].toString();
                          description.text =
                              signataire['role'].toString().toUpperCase();
                          role.text = signataire['prenom'].toString();
                        });
                      },
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 11),
                    child: Text(
                      "NOM",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    )),
                Container(
                  height: MediaQuery.of(context_).size.height * 0.05,
                  width: MediaQuery.of(context_).size.width * 0.08,
                  margin: EdgeInsets.only(
                    left: 3,
                    right: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        width: 1.0, color: Color.fromARGB(218, 219, 219, 215)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(
                      readOnly: true,
                      controller: nom,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nom",
                        contentPadding: EdgeInsets.only(
                          left: 9,
                        ),
                        hintStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 11),
                    child: Text(
                      "PRENOM",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    )),
                Container(
                  height: MediaQuery.of(context_).size.height * 0.05,
                  width: MediaQuery.of(context_).size.width * 0.08,
                  margin: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        width: 1.0, color: Color.fromARGB(218, 219, 219, 215)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(
                      readOnly: true,
                      controller: role,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Prenom",
                        contentPadding: EdgeInsets.only(
                          left: 9,
                        ),
                        hintStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 11),
                    child: Text(
                      "ROLE",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    )),
                Container(
                  height: MediaQuery.of(context_).size.height * 0.05,
                  width: MediaQuery.of(context_).size.width * 0.08,
                  margin: EdgeInsets.only(
                    left: 3,
                    right: 3,
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                        width: 1.0, color: Color.fromARGB(218, 219, 219, 215)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: TextFormField(
                      readOnly: true,
                      controller: description,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Role",
                        contentPadding: EdgeInsets.only(
                          left: 9,
                        ),
                        hintStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    height: MediaQuery.of(context_).size.height * 0.04,
                    width: MediaQuery.of(context_).size.width * 0.08,
                    decoration: BoxDecoration(
                      color: Color(0xFF333333),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "ENREGISTRER",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                  onTap: () async {
                    if (nom.text.isEmpty ||
                        description.text.isEmpty ||
                        role.text.isEmpty) {
                      messageErreur = "Champs vides";
                    } else {
                      dynamic response_ = await etatRealisationProvider
                          .addSignataire(signataire, idEdl);
                      if (response_['existe'] != null) {
                        var snackBar = SnackBar(
                            content: Text('Ce signataire est déjà présent'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        Navigator.pop(context_, 'OK');
                      }
                    }
                  },
                ),
              ])),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Future res = Provider.of<EtatRealisationProvider>(context)
        .getSignatairesEdl(globals.getString("edlId"));
    List<Widget> listeSignataire = [];
    res.then((value) {
      signataires = value;
    });

    Future res1 = Provider.of<EtatRealisationProvider>(context)
        .getParticipantsClient(globals.getString("idClient"));
    res1.then((value) {
      listeSignataireToAdd = value;
    });

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
                      couleur1: Color.fromRGBO(17, 45, 194, 0.11),
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
                      couleur2: Colors.transparent,
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
                          couleur1: Colors.white,
                          couleur2: Colors.black,
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
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.03,
              color: Color.fromRGBO(174, 184, 234, 0.19),
              padding: EdgeInsets.only(
                left: 17,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Signatures".toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Futura.LT'),
                    ),
                    InkWell(
                        onTap: () {
                          Future res1 =
                              etatRealisationProvider.getParticipantsClient(
                                  globals.getString("idClient"));
                          res1.then((value) {
                            displayFormSignataire(idEdl, context, value);
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                            "Ajouter",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Futura.LT',
                                color: Colors.black),
                          ),
                        ))
                  ])),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: signataires.map((e) {
              //print(e);
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 17),
                    child: Text(
                      e['nom'].toString().toUpperCase() +
                          " " +
                          e["prenom"].toString().toUpperCase(),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Futura.LT'),
                    ),
                  ),
                  SignaturePad(
                    e: e,
                  )
                ],
              );
            }).toList(),
          ),
        ]));
  }
}
