import 'dart:typed_data';
import 'package:ams_mobile/conteneurmenu.dart';
import 'package:ams_mobile/piece.dart';
import 'package:ams_mobile/rubriquelist.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:flutter/material.dart';
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
//  Uint8List? exportedImage;
  //late  SignatureController _controller ;
 /* final SignatureController _controller = SignatureController(
    penStrokeWidth: 5.0,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );*/

  
  
  @override
  
  Widget build(BuildContext context) {
    return  Scaffold(
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
                      text: "COMPTEUR",
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
                )
              ]),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.03,
            color: Color.fromRGBO(174, 184, 234, 0.19),
            padding: EdgeInsets.only(left: 17,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Signatures".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,fontFamily: 'Futura.LT'),),
                InkWell(
                  onTap: () {
                    
                  },
                  child:  Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text("Ajouter",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,fontFamily: 'Futura.LT',color: Colors.black),
                    ),
                  )
                  )
         ] )
                
               
                
                
              ),
        
         
           Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 10,left: 17),
              child: Text("Signature 1".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,fontFamily: 'Futura.LT'),),),
              SignaturePad(),
               Padding(padding: EdgeInsets.only(top: 10,left: 17),
              child: Text("Signature 2".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,fontFamily: 'Futura.LT'),),) ,
              SignaturePad(),
               Padding(padding: EdgeInsets.only(top: 10,left: 17),
              child: Text("Signature 3".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,fontFamily: 'Futura.LT'),),),
              SignaturePad(),// Add the SignaturePad widget here
               
              
              SizedBox(height: 16),
             /* InkWell(
                child:Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.06,
                margin: EdgeInsets.only(left: 17,right: 17,top: 15), 
                decoration: BoxDecoration(
                  color:Color.fromRGBO(51, 51, 51, 1)
                ),
                child: Center(child: Text('SAUVEGARDER',style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,fontFamily: 'Futura.LT',color: Colors.white),),)
                ),
                onTap: () {

                  // Access the captured signature
                  final signature = _controller.toPngBytes();
                  // Do something with the signature data
                  // For example, save it or send it to a server
                },
              
              ),*/
           ],
          ),
     
   
      ] )
      
    );
  }
}