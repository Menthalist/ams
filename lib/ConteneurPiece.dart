import 'package:flutter/material.dart';
class ConteneurPiece extends StatelessWidget {
  
  String text;
  ConteneurPiece({required this.text});


  @override
  Widget build(BuildContext context) {
    return Container(
       width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.03,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(174, 184, 234, 0.19),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 7),
            child: Text(
                  text,
                  style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: "FuturaLT.ttf"),
                ),
          )),
    );
  }
}