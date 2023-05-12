import 'package:ams_mobile/controller/AuthController/AuthController.dart';
import 'package:ams_mobile/listescles.dart';
import 'package:ams_mobile/view/connexion/Login.dart';
import 'package:ams_mobile/view/parameters/Parameters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/etat_realisation.dart';
import '../view/home/Home.dart';
import '../pagenavigation/agenda.dart';
import '../pagenavigation/notification.dart';
import '../pagenavigation/profil.dart';
import '../pagenavigation/realisation.dart';

class AppLayout extends StatefulWidget {
  final dynamic authData;
  const AppLayout({Key? key, this.authData}) : super(key: key);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final EtatRealisationProvider etatRealisationProvider =
      EtatRealisationProvider();
  int btn = 0;
  /* TextStyle optionStyle =
  TextStyle(fontSize: 80, fontWeight: FontWeight.bold);*/
  final List<Widget> _widgetOptions = <Widget>[
    const Home(), // 0
    const agenda(), // 1
    const notification(), // 2
    //notification(),
    const realisation(), // 3
    const profil(), // 4
    const Parameters() // 5
  ];

  late SharedPreferences prefs;

  final AuthenticationController _authenticationController =
      AuthenticationController();

  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    etatRealisationProvider.getItems();
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void deconnexion(BuildContext myContext) async {
    setState(() {
      loading = true;
    });
    String refreshToken = prefs.getString("refreshToken") as String;
    String accessToken = prefs.getString("accessToken") as String;

    var isLogout =
        _authenticationController.seDeconnecter(refreshToken, accessToken);
    isLogout.then((value) async => {
          setState(() {
            loading = false;
          }),
          if (value == true)
            {
              await prefs.remove("accessToken"),
              await prefs.remove("refreshToken"),
              Navigator.push(myContext, MaterialPageRoute(builder: (myContext) {
                return const Login();
              })),
            }
          else
            {
              /// pop up no connection available
            }
        });
  }

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: etatRealisationProvider,
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          backgroundColor: Colors.white,
          actions: [
            InkWell(
                onTap: (() {
                  showModalBottomSheet(
                      elevation: 4.0,
                      context: context,
                      builder: (context) {
                        return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: GestureDetector(
                                  onTap: () {
                                    deconnexion(context);
                                  },
                                  child: const Text(
                                    'Deconnexion',
                                    style: TextStyle(
                                      fontFamily: "FuturaLT.ttf",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]);
                      });
                }),
                child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: Icon(
                      Icons.settings,
                      size: 25,
                      color: Colors.black,
                    )))
          ],
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          fixedColor: Colors.black,
          unselectedItemColor: Colors.black,
          currentIndex: btn,
          onTap: _onItemTapped,
          items: const [
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
      ),
    );
  }
}
