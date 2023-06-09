import 'dart:typed_data';

import 'package:ams_mobile/style.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  Uint8List? exportedImage;
  final _formkey = GlobalKey<FormState>();
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5.0,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Signature(
          controller: _controller,
          height: MediaQuery.of(context).size.height*0.14,
          width: MediaQuery.of(context).size.width*0.92,
          backgroundColor: Color.fromRGBO(237, 237, 237, 1),
        ),
        Padding(padding: EdgeInsets.only(top: 10)),
         Form(
              key: _formkey,
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                 
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height*0.05,
                      margin: EdgeInsets.only(left: 20,right: 20,top: 10 ),
                   
                    decoration: boxDecoration(radius: 3,colors: Colors.transparent ,
                        taille: 1, colorbordure: Colors.white),
                    child:  TextFormField(
                      //controller: _controllerr,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Paraphé',
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
      Padding(padding: EdgeInsets.only(top: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: ElevatedButton(onPressed: (){
                   _controller.clear();
                }, child: Text("EFFACER"),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.black)
                ),
                ),
              ),
              
              Padding(
                padding:  EdgeInsets.only(left: 30,right: 20),
                child: ElevatedButton(onPressed: (){
                    final signature = _controller.toPngBytes();
                }, child: Text("ENREGISTRER"),
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.red),
                  
                ),
                ),
              ),
            
            
          ],
        )
      ],
          )
          ) 
          ]);
  }
}
  
