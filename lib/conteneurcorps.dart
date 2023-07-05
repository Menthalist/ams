import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
class conteneurcorps extends StatelessWidget {
 final String text, nomb;
 final Color couleur,col,cal,colbordure,colorg;
  

 conteneurcorps({required this.text,required this.nomb,required this.couleur,required this.colbordure,required this.col,required this.cal,required this.colorg});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          width: MediaQuery.of(context).size.width*0.27,
          height: MediaQuery.of(context).size.height*0.2,
          decoration: BoxDecoration(
            color: couleur,
            border: GradientBoxBorder(gradient: LinearGradient(colors: [colbordure, colorg]),width: 2, ),
            borderRadius: BorderRadius.circular(10),
             boxShadow: 
               const[ BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: Offset(0,4),
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                )]
           
          ),
          child: ListView(children: [
            Padding(padding: EdgeInsets.only(top: 5,left: 9),child: Text(text,style: TextStyle( color: col,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: "FuturaLT.ttf"),
                textAlign: TextAlign.start,
                 ),
                ),
                Padding(padding: EdgeInsets.only(top: 28),child: Center(
                  child: Text(nomb,style: TextStyle( color: cal,
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  fontFamily: "FuturaLT.ttf"),
                  
                   ),
                ),
                ),

          ]),


        ),
      ],
    );
  }
}