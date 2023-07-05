import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/conteneurcorps.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../etatdelieu/etatUI.dart';
import '../../etatdelieu/liste_etat.dart';
import '../../logement.dart';
import '../../piece.dart';
import '../../providers/etat_realisation.dart';

class Home extends StatefulWidget {
  final dynamic authData;

  const Home({Key? key, this.authData}) : super(key: key);

  final String text1 = "13";
  final String text2 = "864";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SharedPreferences globals;
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  List<EtatRealisation> etat1 = [];
  final List<String> _etat = [
    "EDL SORTANT APPROUVE",
    "EDL ENTRANT APPROUVE",
    "EDL SORTANT REPORTE",
    "EDL ENTRANT REPORTE",
    "EDL ENTRANT ANNULE",
    "EDL SORTANT ANNULE"
  ];

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      globals.setString("urlImage1", "");
      globals.setString("urlImage2", "");
      globals.setString("urlImage3", "");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setState(() {});
    initSharedPref();
    etatRealisationProvider.getItems();
    super.initState();
  }

  String _selectedetat = "EDL SORTANT APPROUVE";
  String totalEdl = "";

  @override
  Widget build(BuildContext context) {
    etat1 = Provider.of<EtatRealisationProvider>(context).getEtats;
    etat1 = etat1.reversed.toList();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var total = etat1.length.toString();

    totalEdl = total;
    return Scaffold(
        body: ListView(children: [
      Column(
        children: [
          conteneur(
            text: "TABLEAU DE BORD",
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.22,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 17,
                    color: Color.fromARGB(15, 240, 96, 96),
                  ),
                ],
                color: const Color.fromARGB(15, 240, 96, 96),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 4,
                  color: const Color.fromRGBO(221, 4, 4, 0.25),
                )),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding:
                                EdgeInsets.only(left: 5, bottom: 35, top: 15),
                            child: Text(
                              "TOTAL D'ETAT DES LIEUX",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "FuturaLT.ttf",
                                  fontWeight: FontWeight.w500),
                            )),
                        Row(children: [
                          Padding(
                              padding: EdgeInsets.only(bottom: 35, top: 15),
                              child: Text(
                                widget.text1,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontFamily: "FuturaLT.ttf",
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(239, 201, 10, 10),
                                ),
                              )),
                          Padding(
                            padding:
                                EdgeInsets.only(bottom: 35, right: 25, top: 15),
                            child: Icon(
                              Icons.favorite_border_outlined,
                              color: Color.fromARGB(239, 201, 10, 10),
                              size: 18,
                            ),
                          ),
                        ]),
                      ]),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        totalEdl,
                        style: TextStyle(
                          fontSize: 42,
                          fontFamily: "FuturaLT.ttf",
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(239, 201, 10, 10),
                        ),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
      const SizedBox(
        height: 13,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: etat_realisation.map((e) {
          return conteneurcorps(
            text: e['titre'],
            nomb: e['numero'],
            couleur: e['couleurcontainer'],
            // Color.fromRGBO(136, 255, 95, 0.16),
            cal: e['couleurtext'],
            colbordure: e['bordure'],
            col: e['couleurtext'],
            colorg: e['colorgr'],
          );
        }).toList(),
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Padding(
              padding: EdgeInsets.only(left: 13, top: 8),
              child: Text(
                "Etats des lieux",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'FuturaLT.ttf',
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: InkWell(
                onTap: (() {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                          title: const Text(
                            "FILTRES PAR ",
                            style: TextStyle(
                                fontFamily: "futura.LT",
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                            textAlign: TextAlign.left,
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(children: [
                              for (int i = 0; i < _etat.length; i++)
                                Row(
                                  children: [
                                    Radio(
                                        value: _etat[i].toString(),
                                        groupValue: _selectedetat,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedetat = value.toString();
                                          });
                                        }),
                                    Text(
                                      _etat[i],
                                      style: const TextStyle(
                                          fontFamily: "futura.LT",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                            ]),
                          )));
                }),
                child: const Image(
                  image: AssetImage("assets/img/vector.png"),
                ),
              ))
        ],
      ),
      Column(
          children: etat1.map((e) {
        return etatUIdesign(
          change: () {
            var id = e.id;
            if (id != null) {
              globals.setString("edlId", id);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Logement()));
            }
          },
          etat: e.etat,
          textedl: e.rue,
          typedl: e.edl,
          signature: e.etat,
          commentaire: e.description,
          nbrecom: e.nbrecom,
          nbrepar: e.participant,
          nbrepiece: e.pieces,
          datej: e.date,
        );
      }).toList()),
    ]));
  }
}
