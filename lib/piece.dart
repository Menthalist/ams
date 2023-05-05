import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'conteneurmenu.dart';
import 'listecompteurs.dart';
import 'listescles.dart';
class piececonteneur extends StatefulWidget {
   

  @override
  State<piececonteneur> createState() => _piececonteneurState();
}

class _piececonteneurState extends State<piececonteneur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            child:const Padding(
           padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child:Icon(Icons.settings,size: 25,color: Colors.black,)
          ),
           onTap: () {
            
                
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title:const Text(
          "AMEXPERT",
          //textAlign: TextAlign.right,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'FuturaLT.ttf',
              color: Colors.black),
        ),
      ),
      body: Column(children: [
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
                        
                      },
                  ),
                ),
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: InkWell(
                        child: button(
                        text: "PIECES",
                        couleur1: Colors.white,couleur2: Colors.black,),
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
                        couleur1: Color.fromRGBO(17, 45, 194, 0.11),couleur2: Colors.transparent,),
                         onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => rubriqueliste()));
                      } )
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
                      child: button(text: "COMPTEUR", couleur1: Colors.white,couleur2: Colors.black,),
                      onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => listecompteur()));
                      },

                    ),
                    )
              ]),
            ),
            
        ),
        

      ]),
    );
  }
}