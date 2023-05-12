import 'package:ams_mobile/listescles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/material/bottom_navigation_bar.dart';

import '../Acceuil/acceuil.dart';
import '../pagenavigation/agenda.dart';
import '../pagenavigation/notification.dart';
import '../pagenavigation/profil.dart';
import '../pagenavigation/realisation.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  int btn = 0;
  /* TextStyle optionStyle =
  TextStyle(fontSize: 80, fontWeight: FontWeight.bold);*/
  List<Widget> _widgetOptions = <Widget>[
    acceuil(),
    agenda(),
    notification(),
    //notification(),
    realisation(),
    profil()
  ];
  void _onItemTapped(int index) {
    setState(() {
      btn = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            child:const Padding(
           padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child:Icon(Icons.settings,size: 25,color: Colors.black,)
          ),
           onTap: () {
             Navigator.push(
                context, MaterialPageRoute(builder: (context) => listcle()));
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
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title:const Text(
          "AMEXPERT",
          //textAlign: TextAlign.right,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'FuturaLT.ttf',
              color: Colors.black),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: btn,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32,
            ),
            label: "Acceuil",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month,
                size: 32,
              ),
              label: "Agenda"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 32,
              ),
              label: "Notification"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.data_thresholding,
                size: 32,
              ),
              label: "Realisation"),
          BottomNavigationBarItem(
              icon: Image(
                image: AssetImage("assets/img/profil.png"),
                
              ),
              label: ""),
          // BottomNavigationBarItem(icon: Icon(Icons.key,size: 10,)),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(btn),
      ),
    );
  }
}
