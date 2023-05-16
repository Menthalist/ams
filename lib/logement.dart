import 'package:ams_mobile/piece.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:flutter/material.dart';

import 'button.dart';
import 'conteneur.dart';
import 'listecompteurs.dart';
import 'listescles.dart';
class Logement extends StatefulWidget {
  
   String type_piece1=" 1 Salon",piece=" 4 PIECES",type_piece2="",type_piece3="",type_piece4="";
  


  @override
  State<Logement> createState() => _LogementState();
}

class _LogementState extends State<Logement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:AppBar(
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
                        couleur1: Colors.white,couleur2: Colors.black,),
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
                      child: button(text: "COMPTEUR",couleur1:Color.fromRGBO(17, 45, 194, 0.11),couleur2: Colors.transparent),
                      onTap: () {
                         Navigator.push(
                context, MaterialPageRoute(builder: (context) => listecompteur()));
                      },

                    ),
                    )
              ]),
            ),
            
        ),
        Container(
          margin: EdgeInsets.only(top: 20, left: 10,right: 10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.12,
          decoration: const BoxDecoration(
             color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                spreadRadius: -1,
                 offset: Offset.zero,

              )
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10,top: 5,bottom: 5,),
            width: MediaQuery.of(context).size.width*0.25,
            child: const  Image(image: AssetImage("assets/img/pie1.png",),
           fit: BoxFit.cover)),
           Column(
           crossAxisAlignment: CrossAxisAlignment.end,
           mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5,right: 10),
                child: Text(widget.piece.toUpperCase(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,fontFamily: "Futura.LT"),)),
                Padding(
                padding: const EdgeInsets.only(left: 10, top: 5,right: 10),
                child: Text(widget.type_piece1.toUpperCase(),style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,fontFamily: "Futura.LT"),))
            ],
           )
           
        ],
      ),
        )
        

      ]),
    );
  }
}