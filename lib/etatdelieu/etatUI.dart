import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';




class etatUIdesign extends StatelessWidget {
  final String textedl, typedl, commentaire, signature,nbrepar, nbrepiece, nbrecom,datej;
  final Color couleurconteneur, couleurbordure, couleursigna;
  etatUIdesign(
      {
      required this.textedl,
      required this.typedl,
      required this.commentaire,
      required this.signature,
      required this.nbrepiece,
      required this.nbrepar,
      required this.datej,
      required this.couleurconteneur,
      required this.couleurbordure,
      required this.couleursigna,
      required this.nbrecom});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 13,top: 20,right: 13 ),
      padding: EdgeInsets.only(top: 5, left: 5,),
      height: MediaQuery.of(context).size.height * 0.22,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: couleurconteneur,
          border:Border(left: BorderSide(color:couleurbordure, width:6.0,style:BorderStyle.solid)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0,4),
              color: Color.fromRGBO(0, 0, 0, 0.1),
            )
          ]
          
          ),
         // borderRadius: BorderRadius.circular(8)), 
            child: ListView(
              children: [
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: 10, top: 0),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 26,
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 2, left: 10),
                      child: Text(
                        textedl,
                        style: TextStyle(
                            fontFamily: "FuturaLT.ttf",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 15),
                      child: Text(
                        typedl,
                        style: TextStyle(
                            fontFamily: "FuturaLT.ttf",
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 135),
                      child: Text(
                        signature,
                        style: TextStyle(
                            fontFamily: "FuturaLT.ttf",
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: couleursigna),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 15,right: 25),
                  child: Text(
                    commentaire,
                    style: TextStyle(
                      fontFamily: "FuturaLT.ttf",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      
                    ),textAlign: TextAlign.justify,

                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 15),
                  child: Text(
                    "$nbrecom autres commentaires",
                    style: TextStyle(fontFamily: 'FuturaLT.ttf',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    decoration: TextDecoration.underline),
                  ),
                ),
                
                  Row(
                  children: [
                  Padding(padding: EdgeInsets.only(top: 10, left: 15),
                  child: Text(
                      "$nbrepar Participants",
                      style: TextStyle(fontFamily: 'FuturaLT.ttf',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,decoration:TextDecoration.underline),
                    ),
                ),
                Padding(padding: EdgeInsets.only(top: 10, left: 15),
                  child: Text(
                      "$nbrepiece pièces commentés",
                      style: TextStyle(fontFamily: 'FuturaLT.ttf',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      decoration:TextDecoration.underline),
                      
                    ),

                ),
                Padding(padding: EdgeInsets.only(top: 10, left: 40),
                  child: Text(
                      "$datej",
                      style: TextStyle(fontFamily: 'FuturaLT.ttf',
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      ),
                    ),

                ),
               ] )

              ],
            ),
          );
    
  }
}
