import 'package:ams_mobile/conteneur.dart';
import 'package:flutter/material.dart';

import '../style.dart';
class profil extends StatefulWidget {
  const profil({Key? key}) : super(key: key);

  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {
  final _formkey = GlobalKey<FormState>();
  final _formkeyy = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children:[
           
           conteneur(text: "PROFIL"),
            SizedBox(height: 10,),
            Container(
              child: Column(
                children:  [
                  const CircleAvatar(
                    
                    radius: 30,
                    child: Image(image: AssetImage("assets/img/profil.png"),
                    fit: BoxFit.fill,)
                  ),
                  SizedBox(height: 15,),
                  Text(' TAGNE FABRICE ',style: Styles(taille:15, colors: Couleur().black),),
                  SizedBox(height: 10,),
                  Text(' Agent secteur',style: Styles(taille:15, colors: Couleur().black),),
                ],
              )
            ),
            SizedBox(height:15),
            Form(
              key: _formkey,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                      margin: EdgeInsets.only(left: 15,top: 10),
                      child: Text('Email/Adresse', style: Style(taille: 16, colors: Couleur().black),)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.08,
                      margin: EdgeInsets.only(left: 15,right: 15,top: 10 ),
                   
                    decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                        taille: 1, colorbordure: Colors.white),
                    child:  TextFormField(
                      //controller: _controllerr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'veillez remplir le champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height:5),
                  Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text('Prenom', style: Style(taille: 16, colors: Couleur().black),)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.08,
                      margin: EdgeInsets.only(left: 15,right: 15,top: 10 ),
                   
                    decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                        taille: 1, colorbordure: Colors.white),
                    child:  TextFormField(
                      //controller: _controllerr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'veillez remplir le champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height:5),
                  Container(
                   margin: EdgeInsets.only(left: 15),
                      child: Text('nom', style: Style(taille: 16, colors: Couleur().black),)),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.08,
                      margin: EdgeInsets.only(left: 15,right: 15,top: 10 ),
                    decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                        taille: 1, colorbordure: Colors.white),
                    child:  TextFormField(
                      //controller: _controllerr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '',
                          labelStyle: TextStyle(fontWeight: FontWeight.w700)
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'veillez remplir le champ';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height:5),
                  GestureDetector(
                    onTap: (){
                      if(_formkey.currentState!.validate()){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(' veillez remplir les champs')
                        ));
                      }
                    },
                    child: Container(
                       width: MediaQuery.of(context).size.width,
                       height: MediaQuery.of(context).size.height*0.06,
                        margin: EdgeInsets.only(left: 15, right: 15),
                        padding: EdgeInsets.all(10),
                        decoration: boxDecoration(radius: 3,colors: Couleur().marron1,
                            taille: 1, colorbordure: Colors.transparent),
                        child: Center(child: Text('MODIFIER', style: Style(taille: 16, colors: Couleur().white),))),
                  ),
                ]
              )
            ),

            SizedBox(height:20),
            Form(
              key: _formkeyy,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                     margin: EdgeInsets.only(left: 15,top: 10),
                        child: Text('MODIFIER MOT DE PASSE', style: Style(taille: 16, colors: Couleur().black),)
                    ),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15,right: 15,top: 10 ),
                        child: Text('Mot de passe actuel', style: Style(taille: 16, colors: Couleur().black),)),
                    Container(
                       width: MediaQuery.of(context).size.width,
                       height: MediaQuery.of(context).size.height*0.08,
                      margin: EdgeInsets.only(left: 15, right: 15,top: 10),
                      decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                          taille: 1, colorbordure: Colors.white),
                      child:  TextFormField(
                        //controller: _controllerr,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'veillez remplir le champ';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(left: 15,right: 15,top: 10 ),
                        child: Text('Mouveau mot de passe', style: Style(taille: 16, colors: Couleur().black),)),
                    Container(
                       width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.08,
                      
                      margin: EdgeInsets.only(left: 15, right: 15,top: 10),
                      decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                          taille: 1, colorbordure: Colors.white),
                      child:  TextFormField(
                        //controller: _controllerr,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'veillez remplir le champ';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height:5),
                    Container(
                       width: MediaQuery.of(context).size.width,
                    
                      margin: EdgeInsets.only(left: 15,right: 15,top: 10 ),
                        child: Text('confirme nouveau mot de passe', style: Style(taille: 18, colors: Couleur().black,),)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.08,
                      margin: EdgeInsets.only(left: 15, right: 15,top: 10),
                      decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                          taille: 1, colorbordure: Colors.white),
                      child:  TextFormField(
                        //controller: _controllerr,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: '',
                            labelStyle: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'veillez remplir le champ';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height:5),
                    GestureDetector(
                      onTap: (){
                        if(_formkeyy.currentState!.validate()){
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(' veillez remplir les champs')
                          ));
                        }
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          padding: EdgeInsets.all(10),
                           width: MediaQuery.of(context).size.width,
                           height: MediaQuery.of(context).size.height*0.06,
                          decoration: boxDecoration(radius: 3,colors: Couleur().marron1,
                              taille: 1, colorbordure: Colors.transparent),
                          child: Center(child: Text('MODIFIER', style: Style(taille: 16, colors: Couleur().white),))),
                    ), 
                  ],
                )
            ),
          ]
        )
      )
    );
  }
}

   