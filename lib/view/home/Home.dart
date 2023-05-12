import 'dart:math';

import 'package:ams_mobile/conteneur.dart';
import 'package:ams_mobile/conteneurcorps.dart';
import 'package:ams_mobile/etatdelieu/etat_de_lieu_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../../etatdelieu/etatUI.dart';
import '../../etatdelieu/liste_etat.dart';
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
  List<EtatRealisation> etat1 = [];
  final List<String> _etat = [
    "EDL SORTANT APPROUVE",
    "EDL ENTRANT APPROUVE",
    "EDL SORTANT REPORTE",
    "EDL ENTRANT REPORTE",
    "EDL ENTRANT ANNULE",
    "EDL SORTANT ANNULE"
  ];

  String _selectedetat = "EDL SORTANT APPROUVE";
  @override
  Widget build(BuildContext context) {
    etat1 = Provider.of<EtatRealisationProvider>(context).getEtats;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            child: Column(
              children: [
                Row(children: [
                  const Padding(
                      padding: EdgeInsets.only(left: 5, bottom: 35, top: 15),
                      child: Text(
                        "NOMBRE D'ETAT DE LIEUX REALISES",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "FuturaLT.ttf",
                            fontWeight: FontWeight.w500),
                      )),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 40, bottom: 35, top: 15),
                      child: Text(
                        widget.text1,
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: "FuturaLT.ttf",
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(239, 201, 10, 10),
                        ),
                      )),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 35, left: 4, top: 15),
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: Color.fromARGB(239, 201, 10, 10),
                      size: 18,
                    ),
                  )
                ]),
                const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "864",
                      style: TextStyle(
                        fontSize: 42,
                        fontFamily: "FuturaLT.ttf",
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(239, 201, 10, 10),
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
      const SizedBox(
        height: 13,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        children: [
          const Padding(
              padding: EdgeInsets.only(left: 13, top: 8),
              child: Text(
                "Etats des lieux",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'FuturaLT.ttf',
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(left: 250, top: 10),
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
