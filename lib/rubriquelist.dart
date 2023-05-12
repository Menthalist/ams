import 'dart:math';

import 'package:ams_mobile/conteneurrubrique.dart';
import 'package:ams_mobile/list_rubrique.dart';
import 'package:ams_mobile/listescles.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'conteneur.dart';
import 'conteneurmenu.dart';
import 'listecompteurs.dart';
import 'logement.dart';
import 'piece.dart';
class rubriqueliste extends StatefulWidget {
  const rubriqueliste({super.key});

  @override
  State<rubriqueliste> createState() => _rubriquelisteState();
}

class _rubriquelisteState extends State<rubriqueliste> {
  @override
  Widget build(BuildContext context) {
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
      body:  ListView(
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
                        couleur1: Color.fromRGBO(17, 45, 194, 0.11), couleur2: Colors.transparent,),
                         onTap: () {
                        Navigator.push(
                context, MaterialPageRoute(builder: (context) => Logement()));
                      },
                  ),
                ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: InkWell(
                        child: button(
                        text: "PIECES",
                        couleur1: Color.fromRGBO(17, 45, 194, 0.11),couleur2: Colors.transparent,),
                         onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => piececonteneur()));
                      },
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: InkWell(
                        child: button(
                        text: "RUBRIQUES",
                        couleur1: Colors.white,couleur2: Colors.black,),
                         onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => rubriqueliste()));
                      },
                      ),
                    ),
                     Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: InkWell(
                        child: button(
                        text: "CLES",
                        couleur1: Color.fromRGBO(17, 45, 194, 0.11),couleur2: Colors.transparent,),
                         onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => listcle()));
                      },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 5),
                    child: InkWell(
                      child: button(text: "COMPTEUR", couleur1: Color.fromRGBO(17, 45, 194, 0.11),couleur2: Colors.transparent,),
                      onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => listecompteur()));
                      },

                    ),
                    )
              ]),
            ),
          ),
          //Padding(padding: EdgeInsets.only()),
          InkWell(child: conteneurmenu(text1: "Rubriques", nomb: "6", text2: "AJOUTER"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
                children: list_rubrique.map((e) {
                  return conteneurrubrique(
                    piece: e['piece'],
                    nbrei: e['nbrei'],
                    nbrem: e['nbrem'],
                    typepi:e['typepi'],
                    image: e['image'],
                       
                  );
                }).toList(),
            ),
          ),
         ] )
    );
  }
}