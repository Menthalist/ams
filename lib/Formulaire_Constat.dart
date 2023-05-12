import 'package:ams_mobile/camera.dart';
import 'package:ams_mobile/connexion/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Formulaire_Constat extends StatefulWidget {
  const Formulaire_Constat({super.key});
   
  @override
  State<Formulaire_Constat> createState() => _Formulaire_ConstatState();
}


class _Formulaire_ConstatState extends State<Formulaire_Constat> {
  _Formulaire_ConstatState(){
    _selectedval = _ConstatList[0];
    _SelectedVal = _EtatList[0] ;
    _selectedVal = _commentaireList[0];
    _SelectedVAL = _ajoutList[0];
  }
   final _ConstatList = ["rubriques","1","2","3","4"];
  String? _selectedval = "";
  String? _SelectedVAL = "";
  final _ajoutList = ["Informations generales","pièce de tests","Information locataire","Information AGENT CONSTAT","information des clés"];
  final _EtatList = ["A","B","C","D"];
  String _SelectedVal = "";
  final _commentaireList = ["Descriptions","Defauts","Phrases Types","Observations"];
 // String val = "";
  String _selectedVal = "";
  
  
  
  @override
  
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      
      body: ListView(
        children: [
          Text("Formulaire de constat".toUpperCase(),style: TextStyle(
            fontWeight: FontWeight.w900,fontSize: 18,fontFamily: 'Futura.LT',
          ),
          textAlign: TextAlign.left,),
          SizedBox(
            height: MediaQuery.of(context).size.height*0.09,
         
     ),
     Container(
                 margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                 color: Colors.white60,
                   child:DropdownButtonFormField(
                     elevation: 8,
                 value: _selectedval
                 ,
                 items: _ConstatList.map(
                         (e) => DropdownMenuItem(child: Text(e), value: e,)
                 ).toList(),
                 onChanged: (val){
                   setState(() {
                     _selectedval = val as String;
                   });
                 },
                 icon: const Icon(Icons.arrow_drop_down_circle,
                 color: Colors.black,),
                 dropdownColor: Colors.white,
                 decoration: InputDecoration(
                   focusColor: Colors.white,
                   labelText: "faites votre choix",
                   labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),
                   prefixIcon: Icon(
                     Icons.accessibility_new_rounded,
                     color: Colors.black,
                   ),
                   border: UnderlineInputBorder()
                 )
               )
               ),
               SizedBox(height: 15,),
               Row(
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Container(
                       height: MediaQuery.of(context).size.height*0.08,
                       width: MediaQuery.of(context).size.width*0.4,
                       margin: EdgeInsets.symmetric(horizontal: 20),
                       decoration: BoxDecoration(
                         color: Colors.white70,
                         borderRadius: BorderRadius.circular(20),

                       ),

                       child: Container(
                           margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                           height: MediaQuery.of(context).size.height*0.02,
                           color: Colors.black,
                           child: Center(child: Text("ETAT",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),textAlign: TextAlign.center,),),),

                     ),
                   ],),
               SizedBox(height: 5,),

                   Container(
                     margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                     color: Colors.white,
                     child: DropdownButtonFormField(
                         value: _SelectedVal
                         ,
                         items: _EtatList.map(
                                 (e) => DropdownMenuItem(child: Text(e), value: e,)
                         ).toList(),
                         onChanged: (val){
                           setState(() {
                             _SelectedVal = val as String;
                           });
                         },
                         icon: const Icon(Icons.arrow_drop_down_circle,
                           color: Colors.black,),
                         iconSize: 24,
                         dropdownColor: Colors.white,
                         decoration: InputDecoration(
                             focusColor: Colors.white,
                             labelText: "faites votre choix",
                             labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),
                             prefixIcon: Icon(
                               Icons.accessibility_new_rounded,
                               color: Colors.black,
                             ),
                             border: OutlineInputBorder()
                         )
                     ),
                   ),
               SizedBox(height: 5,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   Container(
                     height: MediaQuery.of(context).size.height*0.08,
                     width: MediaQuery.of(context).size.width*0.6,
                     margin: EdgeInsets.symmetric(horizontal: 20),
                     decoration: BoxDecoration(
                       color: Colors.white60,
                       borderRadius: BorderRadius.circular(20),

                     ),

                     child: Container(
                       margin: EdgeInsets.symmetric(vertical: 20,),
                       height: MediaQuery.of(context).size.height*0.02,

                       color: Colors.black,
                       child: Center(child: Text("TYPE DE COMMENTAIRE",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),textAlign: TextAlign.center,),),),

                   ),
                 ],),
               SizedBox(height: 5,),

               Container(
                   margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                   color: Colors.white,
                   child:DropdownButtonFormField(
                     value: _selectedVal
                     ,
                     items: _commentaireList.map(
                             (e) => DropdownMenuItem(child: Text(e), value: e,)
                     ).toList(),
                     onChanged: (val){
                       setState(() {
                         _selectedVal = val as String;
                       });
                     },
                     icon: const Icon(Icons.arrow_drop_down_circle,
                       color: Colors.black,),
                     iconSize: 24,
                     dropdownColor: Colors.white,
                     decoration: InputDecoration(
                         focusColor: Colors.white,
                         labelText: "faites votre choix",
                         labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),
                         prefixIcon: Icon(
                           Icons.accessibility_new_rounded,
                           color: Colors.black,
                         ),
                         border: OutlineInputBorder()
                     )
                 ),
               ),
               SizedBox(height: 5,),
         Container(
             margin: EdgeInsets.symmetric(horizontal: 20),
             height: MediaQuery.of(context).size.height/12,
             width: MediaQuery.of(context).size.width*0.9,
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: Colors.white.withOpacity(0.5)
             ),
             child:Column(
                 children: [
                   TextField(
                     decoration: InputDecoration(
                         labelStyle: TextStyle(
                           color: Colors.black.withOpacity(0.9),
                           fontSize: 20,

                         ),
                         labelText: "Commentaire final"
                     ),
                   ),
             ]
           ),
         ),
               Container(
              child: camera(),),

               SizedBox(height: 40,),

               InkWell(
                 child: Container(
                   width: MediaQuery.of(context).size.width*0.42,
                   height: MediaQuery.of(context).size.width*0.12,
                   margin: EdgeInsets.symmetric(horizontal: 120),
                   decoration: BoxDecoration(
                       color: Colors.black,
                       borderRadius: BorderRadius.circular(10)
                   ),
                   child: Center(child: Text("ENREGISTRER",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white,),textAlign: TextAlign.center,)),
                 ),
                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
                 },
               ),

             ])
         
     );









   
        
  }
}