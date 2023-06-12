import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

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
  late SharedPreferences prefs;

  List<EtatRealisation> _etat = [];
  List<dynamic> _edlJson = [];
  List<dynamic> _pieces = [];
  List<dynamic> _rubriques = [];
  List<dynamic> _clefs = [];
  List<dynamic> _compteurs = [];
  List<dynamic> _commentaires = [];
  UnmodifiableListView<EtatRealisation> get getEtats =>
      UnmodifiableListView(_etat);
  UnmodifiableListView<dynamic> get getCommentaires =>
      UnmodifiableListView(_commentaires);
  UnmodifiableListView<dynamic> get getEdlJsons =>
      UnmodifiableListView(_edlJson);
  UnmodifiableListView<dynamic> get getPieces => UnmodifiableListView(_pieces);
  UnmodifiableListView<dynamic> get getRubriques =>
      UnmodifiableListView(_rubriques);
  UnmodifiableListView<dynamic> get getCompteurs =>
      UnmodifiableListView(_rubriques);
  UnmodifiableListView<dynamic> get getClefs => UnmodifiableListView(_clefs);

  Future addComposant(dynamic composant) async {
    //variables
    var edlBox = await Hive.openBox<dynamic>("edl");
    int i = edlBox.values.length;
    var edl1;
    int index = 0;
    int i_ = 0;
    dynamic composantToAdd = {};
    //initialisation
    var edl = edlBox.values.firstWhere((object) {
      return object['_id'] == composant['edl'];
    });
    for (int k = 0; k <= i - 1; k++) {
      edl1 = edlBox.getAt(k);
      if (edl1['_id'] == composant['edl']) {
        index = k;
      }
    }
    //logique
    if (composant['type'] == "piece") {
      composantToAdd['nom'] = composant['nom'];
      composantToAdd['description'] = composant['description'];
      composantToAdd['etat'] = composant['etat'];
      composantToAdd['num_ordre'] = composant['num_ordre'];
      composantToAdd['rubriq'] = {};
      edl["logement"]['type_log']['piece'].forEach((key, valeur) {
        i_ = i_ + 1;
      });
      i_ = i_ + 1;
      String nom_ = "piece" + i_.toString();
      composantToAdd['_id'] = nom_;
      edl["logement"]['type_log']['piece'][nom_] = composantToAdd;
      await edlBox.putAt(index, edl);
      return edl;
    }
    if (composant['type'] == "rubrique") {
      edl["logement"]['type_log']['piece'].forEach((key, valeur) async {
        if (key == composant['piece']) {
          composantToAdd['nom'] = composant['nom'];
          composantToAdd['description'] = composant['description'];
          composantToAdd['etat'] = composant['etat'];
          composantToAdd['num_ordre'] = composant['num_ordre'];
          int k = 0;
          edl["logement"]['type_log']['piece'][key]["rubriq"]
              .forEach((key, valeur) {
            k = k + 1;
          });
          String nom_ = "rubriq" + k.toString();
          composantToAdd['_id'] = nom_;
          edl["logement"]['type_log']['piece'][key]["rubriq"][nom_] =
              composantToAdd;
          await edlBox.putAt(index, edl);
        }
      });
      return edl;
    }
  }

  Future getItems() async {
    WidgetsFlutterBinding.ensureInitialized();
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    //Hive.registerAdapter(EdlAdapter());
    var edlBox = await Hive.openBox<dynamic>("edl");
    var commentaireBox = await Hive.openBox<dynamic>("commentaire");
    try {
      var result = [];
      result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Uri getAllClient = Uri(
            scheme: "http",
            host: "195.15.228.250",
            path: "edlplanning/edl/tous");

        Uri getAllComments = Uri(
            scheme: "http",
            host: "195.15.218.172",
            path: "edlgateway/api/v1/commentaire/all",
            query: "start=1&limit=2&count=1");
        http.Response response = await http.get(getAllClient, headers: {
          'Authorization':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjkxNDYwLCJpYXQiOjE2ODI0Mjc0NjAsImp0aSI6ImZjNTcwMTJhYzVkNzQ5NTRhNWYyYTU5MjIyZDYxZGI5IiwidXNlcl9pZCI6NzI2fQ.roWIMbNgk4KRzeFaiHecbES63i_WLfhdhdeLsO0xYG8",
        });

        http.Response responsecom = await http.get(getAllComments, headers: {
          'Authorization':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg1ODcxMDI3LCJpYXQiOjE2ODUwMDcwMjcsImp0aSI6ImYzMzNmNzdhOGI1OTRjMzg5YjUzYmUwNTFkYzZkZDY0IiwidXNlcl9pZCI6MjYwfQ.LX0v9YHzGa6sHpW8D13xUu-Q1nguBzwoWg_rALjZG8g",
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
        }
        if (responsecom.statusCode == 200) {
          commentaireBox.deleteAll(commentaireBox.keys);
          (json.decode(responsecom.body)["results"] as List)
              .map((usersJson) async {
            await commentaireBox.add(usersJson);
            usersJson = {};
          }).toList();
          _commentaires.addAll(commentaireBox.values.toList());
          notifyListeners();
          print(_commentaires);
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
          titre: "EDL " +
              (usersJson['type_edl'] == null ? "" : usersJson['type_edl']),
          numero: "",
          rue: "Rue indéfinie",
          edl: usersJson['type_edl'] == null ? "" : usersJson['type_edl'],
          etat: usersJson['avancement'] == null ? "" : usersJson['avancement'],
          description: "Description standard d'un EDL",
          participant: "",
          pieces: "",
          date: usersJson['date_edl'] == null ? "" : usersJson['date_edl'],
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

  getSingleEdl(String id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    return edlBox.values.toList().where((edl) => edl["_id"] == id).toList()[0];
  }

  getSpecificEDL(String _id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    this._pieces = [];
    List liste =
        edlBox.values.toList().where((edl) => edl["_id"] == _id).toList();
    if (liste.isEmpty == false) {
      var edl = liste[0];
      edl["logement"]['type_log']['piece'].forEach((key, value) {
        int i = 0;
        String constate = "oui";
        value["key"] = key.toString();
        value['rubriq'].forEach((ke, val) {
          i = i + 1;
          if (val["constate"] == null) {
            constate = "non";
          }
        });
        if (i == 0) {
          value['constate'] = "non";
        } else {
          value['constate'] = constate;
        }
        value['rubriques'] = i.toString();
        this._pieces.add(value);
      });
    }
    notifyListeners();
    return _pieces;
  }

  getRubriqueOfApiece(String edl, String piece_) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    var edlP = edlBox.values.firstWhere((object) {
      return object['_id'] == edl;
    });
    dynamic piece;

    _rubriques = [];
    edlP["logement"]['type_log']['piece'].forEach((key, value) {
      if (key == piece_) {
        piece = value;
      }
    });

    piece['rubriq'].forEach((key, value) {
      value["key"] = key.toString();
      value['value'] = value['_id'];
      this._rubriques.add(value);
    });
    notifyListeners();
    return _rubriques;
  }

  List getCompteur(_id) {
    _compteurs = [];
    List liste = UnmodifiableListView(
        this.getEdlJsons.where((edl) => edl["_id"] == _id));
    if (liste.isEmpty == false) {
      var piece = liste[0];
      piece['logement']['type_log']['compteur'].forEach((key, value) {
        value["key"] = key.toString();
        this._compteurs.add(value);
      });
    }
    notifyListeners();
    return _compteurs;
  }

  List getClef(_id) {
    _clefs = [];
    List liste = UnmodifiableListView(
        this.getEdlJsons.where((edl) => edl["_id"] == _id));
    if (liste.isEmpty == false) {
      var piece = liste[0];
      piece['logement']['type_log']['cles'].forEach((key, value) {
        value["key"] = key.toString();
        this._clefs.add(value);
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
      BuildContext context,
      String img1,
      String img2,
      String img3) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    int i = edlBox.values.length;
    var edl1;
    int index = 0;

    var edl = edlBox.values.firstWhere((object) {
      return object['_id'] == idEdl;
    });

    for (int k = 0; k <= i - 1; k++) {
      edl1 = edlBox.getAt(k);
      if (edl1['_id'] == idEdl) {
        index = k;
      }
    }
    dynamic rubriqueFinale;
    edl["logement"]['type_log']['piece'].forEach((key, value) {
      if (value['key'] == idPiece) {
        value['rubriq'].forEach((key, valueR) {
          if (valueR['key'] == idRub) {
            valueR['etat'] = etat;
            valueR['description'] = description;
            valueR['commentaire'] = commentaire;
            valueR['commentaireFinal'] = commentaitreFinal;
            valueR['image1'] = img1;
            valueR['image2'] = img2;
            valueR['image3'] = img3;
            valueR['constate'] = "ok";
            value['rubriq'][key] = valueR;
            rubriqueFinale = valueR;
          }
        });
      }
    });

    await edlBox.putAt(index, edl);
    // ignore: use_build_context_synchronously
    displayDialog(context);
    return rubriqueFinale;
  }

  getCommentairesOfanElement(String idEl, String typeCommentaire) async {
    var commentaireBox = await Hive.openBox<dynamic>("commentaire");
    List final_ = [];
    commentaireBox.values.toList().forEach((element) {
      if (element["type"].toString().toLowerCase() ==
              typeCommentaire.toLowerCase() &&
          element["key_"] == idEl) {
        final_.add(element);
        element = {};
      }
    });
    print("dans le provider " + final_.length.toString());
    return final_;
  }

  void add(EtatRealisation item) {
    _etat.add(item);
    notifyListeners();
  }
}
