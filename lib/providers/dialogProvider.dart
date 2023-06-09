import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogProvider{


  void displayFormPiece(BuildContext context_,
      {String text =
          "Attention les données en cours de saisie seront perdues car vous ne les avez pas encore enregistrés. Confirmez-vous cette opération??",
      String titre = "Voulez vous annuler le constat en cours??"}) {
    Text message = Text(text);
    Text title = Text(titre);
    // show the dialog
    showDialog(
                  context: context_,
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
                            height: MediaQuery.of(context_).size.height * 0.05,
                            width: MediaQuery.of(context_).size.width * 0.08,
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
                      
  
  }


  void displayDialogWarning(BuildContext context_,
      {String text =
      
          "Attention les données en cours de saisie seront perdues car vous ne les avez pas encore enregistrés. Confirmez-vous cette opération??",
      String titre = "Voulez vous annuler le constat en cours??"}) {
    Text message = Text(text);
    Text title = Text(titre);
   
   
    // show the dialog
     showDialog(
                  context: context_,
                  builder: (ctx) => AlertDialog(
                        title: Text(
                          "AJOUTER UNE RUBRIQUE ",
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
                            height: MediaQuery.of(context_).size.height * 0.05,
                            width: MediaQuery.of(context_).size.width * 0.08,
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
                      
    
      }
       void displayDialogCompteur(BuildContext context_,
      {String text =
      
          "Attention les données en cours de saisie seront perdues car vous ne les avez pas encore enregistrés. Confirmez-vous cette opération??",
      String titre = "Voulez vous annuler le constat en cours??"}) {
    Text message = Text(text);
    Text title = Text(titre);
   
   
    // show the dialog
     showDialog(
                  context: context_,
                  builder: (ctx) => AlertDialog(
                        title: Text(
                          "AJOUTER UN COMPTEUR ",
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
                            height: MediaQuery.of(context_).size.height * 0.05,
                            width: MediaQuery.of(context_).size.width * 0.08,
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
      }
      void displayFormKey(BuildContext context_,
      {String text =
          "Attention les données en cours de saisie seront perdues car vous ne les avez pas encore enregistrés. Confirmez-vous cette opération??",
      String titre = "Voulez vous annuler le constat en cours??"}) {
    Text message = Text(text);
    Text title = Text(titre);
    // show the dialog
    showDialog(
                  context: context_,
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
                                "NOM",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w900),
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
                      
  
  }
}