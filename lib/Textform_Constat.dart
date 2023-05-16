import 'package:flutter/material.dart';
class Conteneur_formulaire extends StatelessWidget {
 
  final double hauteur;
  final String text;
  Conteneur_formulaire({required this.hauteur,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
     
    height: hauteur,
    width:  MediaQuery.of(context).size.width,
    margin: const EdgeInsets.only(left: 10, right: 10,top: 20),
    decoration: BoxDecoration(
      color: Colors.transparent,
      border:   Border.all(color: Colors.black,width: 0.2),
      boxShadow: const [ BoxShadow(
        color: Colors.white,
         spreadRadius: 1,
         blurRadius: 2,
         offset: Offset(0, 2),

      )
    ]),
    child: TextFormField(
     decoration:  InputDecoration(
       hintText: text,
       border: InputBorder.none,
       contentPadding: const EdgeInsets.only(left: 9, top: 15),
       hintStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
     ),

    ),
    

    );
    
  }
}