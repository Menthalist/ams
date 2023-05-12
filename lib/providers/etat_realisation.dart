import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
  UnmodifiableListView<EtatRealisation> get getEtats =>
      UnmodifiableListView(_etat);
  UnmodifiableListView<dynamic> get getEdlJson =>
      UnmodifiableListView(_edlJson);

  Future getItems() async {
    Uri getAllClient = Uri(
        scheme: "http", host: "195.15.228.250", path: "edlplanning/edl/tous");

    try {
      http.Response response = await http.get(getAllClient, headers: {
        'Authorization':
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjkxNDYwLCJpYXQiOjE2ODI0Mjc0NjAsImp0aSI6ImZjNTcwMTJhYzVkNzQ5NTRhNWYyYTU5MjIyZDYxZGI5IiwidXNlcl9pZCI6NzI2fQ.roWIMbNgk4KRzeFaiHecbES63i_WLfhdhdeLsO0xYG8",
      });
      if (response.statusCode == 200) {
        (json.decode(response.body) as List).map((usersJson) {
          _edlJson.add(usersJson);
          EtatRealisation etat = EtatRealisation(
              titre: "EDL " + usersJson['type_edl'],
              numero: "",
              rue: "Rue indéfinie",
              edl: usersJson['type_edl'],
              etat: usersJson['avancement'],
              description: "Description standard d'un EDL",
              participant: "",
              pieces: "",
              date: usersJson['date_edl'],
              id: usersJson["_id"]);
          _etat.add(etat);
        }).toList();
        this.notifyListeners();
      }
    } catch (e) {
      rethrow;
    }

    /*DateTime date1 = DateTime.utc(2023, 12, 5);
    DateTime date2 = DateTime.utc(2023, 15, 6);
    String day1 = date1.day.toString().length > 1
        ? date1.day.toString()
        : "0" + date1.day.toString();

    String day2 = date2.day.toString().length > 1
        ? date2.day.toString()
        : "0" + date2.day.toString();

    String month1 = date1.month.toString().length > 1
        ? date1.month.toString()
        : "0" + date1.month.toString();

    String month2 = date2.month.toString().length > 1
        ? date2.month.toString()
        : "0" + date2.month.toString();
    _etat = [
      EtatRealisation(
          date: day1 + "/" + month1 + "/" + date1.year.toString(),
          description: "Decsription1",
          edl: "001",
          etat: "realise",
          numero: "12",
          participant: "5",
          pieces: "5",
          rue: "Rue Albert",
          titre: "EDL de Test"),
      EtatRealisation(
          date: day2 + "/" + month2 + "/" + date2.year.toString(),
          description: "Decsription2",
          edl: "002",
          etat: "annule",
          numero: "3",
          participant: "8",
          pieces: "5",
          rue: "Rue Gabriel",
          titre: "EDL de Test1"),
    ];
    this.notifyListeners();*/
  }

  void add(EtatRealisation item) {
    _etat.add(item);
    notifyListeners();
  }
}
