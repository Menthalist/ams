import 'package:flutter/material.dart';
class Appbar_Menu extends StatefulWidget {
  const Appbar_Menu({super.key});

  @override
  State<Appbar_Menu> createState() => _Appbar_MenuState();
}

class _Appbar_MenuState extends State<Appbar_Menu> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        toolbarHeight: 56,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            child:  Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                child: Icon(
                  Icons.settings,
                  size: 25,
                  color: Colors.black,
                )),
            onTap: () {},
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
        title: const Text(
          "AMEXPERT",
          //textAlign: TextAlign.right,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'FuturaLT.ttf',
              color: Colors.black),
        ),
      );
    
  }
}
   