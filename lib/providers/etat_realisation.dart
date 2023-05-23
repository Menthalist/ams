import 'dart:collection';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class EtatRealisation {
  String titre;
  String numero;
  String rue;
  String edl;
  String etat;
  String description;
  String participant;
  String pieces;
  String date;
  String? id;
  String nbrecom = "3";

  EtatRealisation(
      {this.id,
      required this.titre,
      required this.numero,
      required this.rue,
      required this.edl,
      required this.etat,
      required this.description,
      required this.participant,
      required this.pieces,
      required this.date});

  Map<String, dynamic> toJSon() {
    Map<String, dynamic> value = {
      "titre": titre,
      "description": description,
      "rue": rue,
      "edl": edl,
      "etat": etat,
      "participant": participant,
      "pieces": pieces,
      "date": date,
    };
    if (id != null) {
      value['id'] = id;
    }
    return value;
  }

  EtatRealisation._from_json(Map<String, dynamic> json)
      : titre = json['titre'],
        description = json['description'],
        rue = json['rue'],
        edl = json['edl'],
        etat = json['etat'],
        participant = json['participant'],
        pieces = json['pieces'],
        date = json['date'],
        id = json['id'],
        numero = json["numero"];
}

class EtatRealisationProvider extends ChangeNotifier {
  List<EtatRealisation> _etat = [];
  List<dynamic> _edlJson = [];
  List<dynamic> _pieces = [];
  List<dynamic> _rubriques = [];
  List<dynamic> _clefs = [];
  List<dynamic> _compteurs = [];
  UnmodifiableListView<EtatRealisation> get getEtats =>
      UnmodifiableListView(_etat);
  UnmodifiableListView<dynamic> get getEdlJsons =>
      UnmodifiableListView(_edlJson);
  UnmodifiableListView<dynamic> get getPieces => UnmodifiableListView(_pieces);
  UnmodifiableListView<dynamic> get getRubriques =>
      UnmodifiableListView(_rubriques);
  UnmodifiableListView<dynamic> get getCompteurs =>
      UnmodifiableListView(_rubriques);
  UnmodifiableListView<dynamic> get getClefs => UnmodifiableListView(_clefs);

  Future getItems() async {
    WidgetsFlutterBinding.ensureInitialized();
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    var edlBox = await Hive.openBox<dynamic>("edl");
    try {
      var result = [];
      result = await InternetAddress.lookup('example.com');
      print(result);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Uri getAllClient = Uri(
            scheme: "http",
            host: "195.15.228.250",
            path: "edlplanning/edl/tous");
        http.Response response = await http.get(getAllClient, headers: {
          'Authorization':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjkxNDYwLCJpYXQiOjE2ODI0Mjc0NjAsImp0aSI6ImZjNTcwMTJhYzVkNzQ5NTRhNWYyYTU5MjIyZDYxZGI5IiwidXNlcl9pZCI6NzI2fQ.roWIMbNgk4KRzeFaiHecbES63i_WLfhdhdeLsO0xYG8",
        });
        if (response.statusCode == 200) {
          (json.decode(response.body) as List).map((usersJson) async {
            var ln = edlBox.values
                .where((object) => object['_id'] == usersJson['_id'])
                .toList()
                .length;
            if (ln == 0) {
              await edlBox.add(usersJson);
            }
            usersJson = {};
          }).toList();
        } else {
          print('ici');
        }
      } else {
        print('pas de connexion else');
      }
    } on SocketException catch (_) {
      print('pas de connexion');
    }
    List edls = edlBox.values.toList();
    _etat = [];
    edls.forEach((usersJson) {
      _etat.add(EtatRealisation(
          titre: "EDL " + usersJson['type_edl'] == null
              ? ""
              : usersJson['type_edl'],
          numero: "",
          rue: "Rue indéfinie",
          edl: usersJson['type_edl'] == null ? "" : usersJson['type_edl'],
          etat: usersJson['avancement'] == null ? "" : usersJson['avancement'],
          description: "Description standard d'un EDL",
          participant: "",
          pieces: "",
          date: usersJson['date_edl'],
          id: usersJson["_id"]));
      _edlJson.add(usersJson);
      usersJson = {};
    });
    notifyListeners();
    /*DateTime date1 = DateTime.utc(2023, 12, 5);
    DateTime date2 = DateTime.utc(2023, 15, 6);
    String month1 = date1.month.toString().length > 1
        ? date1.month.toString()
        : "0" + date1.month.toString();*/
  }

  List getSpecificEDL(String _id) {
    this._pieces = [];
    List liste =
        UnmodifiableListView(this.getEdlJsons.where((edl) => edl["_id"] == _id))
            .toList();
    //print(this.getEdlJsons);
    if (liste.isEmpty == false) {
      var edl = liste[0];
      edl["logement"]['type_log']['piece'].forEach((key, value) {
        _pieces.add(value);
      });
    }
    return _pieces;
  }

  List<dynamic> getRubriqueOfApiece(_id) {
    _rubriques = [];
    List liste =
        UnmodifiableListView(this.getPieces.where((edl) => edl["_id"] == _id));
    if (liste.isEmpty == false) {
      var piece = liste[0];
      piece['rubriq'].forEach((key, value) {
        value['value'] = value['_id'];
        _rubriques.add(value);
      });
    }
    /* _rubriques.forEach((element) {
      if (element['constate'] != null) {
        _rubriques.insert(_rubriques.length - 1, element);
      }
    });*/
    return _rubriques;
  }

  List getCompteur(_id) {
    _compteurs = [];
    List liste = UnmodifiableListView(
        this.getEdlJsons.where((edl) => edl["_id"] == _id));
    if (liste.isEmpty == false) {
      var piece = liste[0];
      piece['logement']['type_log']['compteur'].forEach((key, value) {
        _compteurs.add(value);
      });
    }
    return _compteurs;
  }

  List getClef(_id) {
    _clefs = [];
    List liste = UnmodifiableListView(
        this.getEdlJsons.where((edl) => edl["_id"] == _id));
    if (liste.isEmpty == false) {
      var piece = liste[0];
      piece['logement']['type_log']['cles'].forEach((key, value) {
        _clefs.add(value);
      });
    }
    return _clefs;
  }

  void displayDialog(BuildContext context_,
      {String text = "Constat effectué avec succès",
      String titre = "Réussite!!!"}) {
    Text message = Text(text);
    Text title = Text(titre);
    // show the dialog
    showDialog(
      context: context_,
      builder: (BuildContext context) => AlertDialog(
        title: title,
        content: message,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  constatRubrique(
      String idEdl,
      String idPiece,
      String idRub,
      String etat,
      String description,
      String commentaire,
      String commentaitreFinal,
      BuildContext context) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    var edl =
        edlBox.values.where((object) => object['_id'] == idEdl).toList()[0];
    print(idPiece);
    edl["logement"]['type_log']['piece'].forEach((key, value) {
      print(value["_id"]);
      if (value['_id'] == idPiece) {
        value['rubriq'].forEach((key, valueR) {
          if (valueR['_id'] == idRub) {
            valueR['etat'] = etat;
            valueR['description'] = description;
            valueR['commentaire'] = commentaire;
            valueR['commentaireFinal'] = commentaitreFinal;
            valueR['constate'] = "ok";
            value['rubriq'][key] = valueR;
            print("ici");
          }
        });
      }
    });
    print("après");
    print(edl["logement"]['type_log']['piece']);
    displayDialog(context);
  }

  void add(EtatRealisation item) {
    _etat.add(item);
    notifyListeners();
  }
}
