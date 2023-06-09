
import 'package:ams_mobile/pagenavigation/agenda.dart';
import 'package:ams_mobile/pagenavigation/notification.dart';
import 'package:ams_mobile/pagenavigation/profil.dart';
import 'package:ams_mobile/pagenavigation/realisation.dart';
import 'package:ams_mobile/piedpage/home.dart';
import 'package:ams_mobile/view/home/Home.dart';
import 'package:ams_mobile/view/parameters/Parameters.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  
  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int currentTab=0;
  final List<Widget> screens = [
       const Home(),
    const agenda(),
    const notification(),
    //notification(),
    const realisation(),
    const profil(),
    const Parameters()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = notification();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: PageStorage(
      child: currentScreen,
      bucket: bucket,
     ),
     floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.black,
      child: Icon(Icons.add),
      onPressed: (() {
        
      }),
     ),
     floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     bottomNavigationBar: BottomAppBar(shape: CircularNotchedRectangle(),
     notchMargin: 10,
     
     child: Container(height: 60,
     child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:<Widget>
      [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaterialButton(
            minWidth: 40,
            onPressed: (() {
              setState(() {
                currentScreen=home();
                currentTab=0;
              });
              
            }
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home),
                Text("Acceuil",style: TextStyle(color: currentTab==0 ? Colors.black : Colors.amber.shade400),)
              ],
            ),
          ),
         
          
        ],

      ),
    
           MaterialButton(
            minWidth: 40,
            onPressed: (() {
              setState(() {
                currentScreen=agenda();
                currentTab=0;
              });
              
            }
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month),
                Text("Agenda",style: TextStyle(color: currentTab==0 ? Colors.black : Colors.amber.shade400),)
              ],
            ),
          ) ,
           MaterialButton(
            minWidth: 40,
            onPressed: (() {
              setState(() {
                currentScreen=notification();
                currentTab=0;
              });
              
            }
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications),
                Text("Notification",style: TextStyle(color: currentTab==0 ? Colors.black : Colors.amber.shade400),)
              ],
            ),
          ),
           
           MaterialButton(
            minWidth: 40,
            onPressed: (() {
              setState(() {
                currentScreen=profil();
                currentTab=0;
              });
              
            }
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Image(
                image: AssetImage("assets/img/profil.png"),
              ),
                Text("Profil",style: TextStyle(color: currentTab==0 ? Colors.black : Colors.amber.shade400),)
              ],
            ),
          )
          ]),
     ),
     ),
    );
  }
}
 