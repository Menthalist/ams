import 'package:flutter/material.dart';
class Couleur{

  var gris = const Color.fromARGB(218, 219, 219, 215);
  var black = const Color.fromARGB(255, 10, 10, 10);
  var white = const Color.fromARGB(255, 255, 253, 253);
  var marron = const Color.fromARGB(255, 201, 197, 197);
  var marron1 = const Color.fromARGB(255, 52, 50, 50);
  }

  TextStyle Styles({Color? colors, double? taille,}){
    return TextStyle(fontSize: taille, color: colors, fontWeight: FontWeight.bold);
  }
TextStyle Style({Color? colors, double? taille,}){
  return TextStyle(fontSize: taille, color: colors,);
}
  BoxDecoration boxDecoration({Color? colors, Color? colorbordure, double? taille, double?  radius}){
  return BoxDecoration(
      border: Border.all(
    width: taille!,
        color: colorbordure!,
  ),
   borderRadius: BorderRadius.circular(radius!),
    color: colors!,
  );
}

enum Choix { oui, non }