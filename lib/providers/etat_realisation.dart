import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:signature/signature.dart';
import 'dart:convert';

import 'package:http_parser/http_parser.dart';
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
      required this.date,
      required this.nbrecom});

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
  List<dynamic> _signataires = [];
  List<dynamic> _participantClient = [];
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
  UnmodifiableListView<dynamic> get getSignatires =>
      UnmodifiableListView(_signataires);
  UnmodifiableListView<dynamic> get getParticipantClient =>
      UnmodifiableListView(_participantClient);

  Future deleteComposant(dynamic composant) async {
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
      dynamic pieces = edl["logement"]['type_log']['piece'];
      pieces.forEach((key, valeur) {
        if (valeur['_id'] == composant['_id']) {
          pieces.remove(key);
        }
      });
      edl["logement"]['type_log']['piece'] = pieces;
      await edlBox.putAt(index, edl);
      return edl;
    }
    if (composant['type'] == "cles") {
      dynamic cles = edl["logement"]['type_log']['cles'];
      cles.forEach((key, valeur) {
        if (valeur['_id'] == composant['_id']) {
          cles.remove(key);
        }
      });
      edl["logement"]['type_log']['cles'] = cles;
      await edlBox.putAt(index, edl);
      return edl;
    }
    if (composant['type'] == "compteur") {
      dynamic compteur = edl["logement"]['type_log']['compteur'];
      compteur.forEach((key, valeur) {
        if (valeur['_id'] == composant['_id']) {
          compteur.remove(key);
        }
      });
      edl["logement"]['type_log']['compteur'] = compteur;
      await edlBox.putAt(index, edl);
      return edl;
    }
    if (composant['type'] == "rubrique") {
      dynamic rubriques =
          edl["logement"]['type_log']['piece'][composant['piece']]['rubriq'];
      rubriques.forEach((key, valeur) {
        if (valeur['_id'] == composant['_id']) {
          rubriques.remove(key);
        }
      });
      edl["logement"]['type_log']['piece'][composant['piece']]['rubriq'] =
          rubriques;
      await edlBox.putAt(index, edl);
      return edl;
    }
  }

  Future deleteParticipant(idEdl, idParticipant) async {
    //variables
    var edlBox = await Hive.openBox<dynamic>("edl");
    int i = edlBox.values.length;
    var edl1;
    int index = 0;
    //initialisation
    var edl = edlBox.values.firstWhere((object) {
      return object['_id'] == idEdl;
    });
    for (int k = 0; k <= i - 1; k++) {
      edl1 = edlBox.getAt(k);
      if (edl1['_id'] == idEdl) {
        index = k;
      }
    }
    edl['signataires'].forEach((key, value) async {
      if (value['id'] == idParticipant) {
        edl['signataires'].remove(key);
        await edlBox.putAt(index, edl);
        return edl;
      }
    });
  }

  Future addSignataire(dynamic signantaire, _id) async {
    //variables
    var edlBox = await Hive.openBox<dynamic>("edl");
    int i = edlBox.values.length;
    var edl1;
    int index = 0;
    int i_ = 1;
    dynamic exist_ = {};
    //initialisation
    var edl = edlBox.values.firstWhere((object) {
      return object['_id'] == _id;
    });
    for (int k = 0; k <= i - 1; k++) {
      edl1 = edlBox.getAt(k);
      if (edl1['_id'] == _id) {
        index = k;
      }
    }
    edl["signataires"].forEach((key, valeur) {
      i_ = i_ + 1;
      if (valeur['id'] == signantaire['id']) {
        exist_["existe"] = "oui";
      }
    });
    if (exist_['existe'] != null) {
      return exist_;
    }
    edl['signataires']["signataire" + (i + 1).toString()] = signantaire;
    await edlBox.putAt(index, edl);
    return edl;
  }

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
      edl["logement"]['type_log']['piece'].forEach((key, valeur) {
        i_ = i_ + 1;
      });
      i_ = i_ + 1;
      String nom_ = "piece" + i_.toString();
      composantToAdd['_id'] = nom_;
      dynamic rubrique = {
        "rubrique1": {
          "_id": nom_.toString() + "_rubrique1",
          "nom": "Mur",
          "description": "Mur interne",
        },
        "rubrique2": {
          "_id": nom_.toString() + "_rubrique2",
          "nom": "Salon",
          "description": "Salon de maison",
        },
        "rubrique3": {
          "_id": nom_.toString() + "_rubrique3",
          "nom": "Plafond",
          "description": "Plafond de maison",
        },
      };
      composantToAdd['rubriq'] = rubrique;
      edl["logement"]['type_log']['piece'][nom_] = composantToAdd;
      await edlBox.putAt(index, edl);
      return edl;
    }

    if (composant['type'] == "compteur") {
      composantToAdd['nom'] = composant['nom'];
      composantToAdd['description'] = composant['description'];
      composantToAdd['etat'] = composant['etat'];
      composantToAdd['num_ordre'] = composant['num_ordre'];
      composantToAdd['id'] = composant['id'];
      edl["logement"]['type_log']['compteur'].forEach((key, valeur) {
        i_ = i_ + 1;
      });
      i_ = i_ + 1;
      String nom_ = "compteur" + i_.toString();
      composantToAdd['_id'] = nom_;
      edl["logement"]['type_log']['compteur'][nom_] = composantToAdd;
      await edlBox.putAt(index, edl);
      return edl;
    }

    if (composant['type'] == "clef") {
      composantToAdd['nom'] = composant['nom'];
      composantToAdd['description'] = composant['description'];
      composantToAdd['etat'] = composant['etat'];
      composantToAdd['num_ordre'] = composant['num_ordre'];
      composantToAdd['id'] = "";
      edl["logement"]['type_log']['cles'].forEach((key, valeur) {
        i_ = i_ + 1;
      });
      i_ = i_ + 1;
      String nom_ = "cles" + i_.toString();
      composantToAdd['_id'] = nom_;
      edl["logement"]['type_log']['cles'][nom_] = composantToAdd;
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
    var participantBox = await Hive.openBox<dynamic>("participant");

    try {
      var result = [];
      result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Uri getAllParticipants = Uri(
            scheme: "http",
            host: "195.15.218.172",
            path: "edlgateway/api/v1/participant/all",
            query: "start=1&limit=1&count=10");

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

        http.Response responseParticipants =
            await http.get(getAllParticipants, headers: {
          'Authorization':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjgzMjkxNDYwLCJpYXQiOjE2ODI0Mjc0NjAsImp0aSI6ImZjNTcwMTJhYzVkNzQ5NTRhNWYyYTU5MjIyZDYxZGI5IiwidXNlcl9pZCI6NzI2fQ.roWIMbNgk4KRzeFaiHecbES63i_WLfhdhdeLsO0xYG8",
        });

        http.Response responsecom = await http.get(getAllComments, headers: {
          'Authorization':
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg1ODcxMDI3LCJpYXQiOjE2ODUwMDcwMjcsImp0aSI6ImYzMzNmNzdhOGI1OTRjMzg5YjUzYmUwNTFkYzZkZDY0IiwidXNlcl9pZCI6MjYwfQ.LX0v9YHzGa6sHpW8D13xUu-Q1nguBzwoWg_rALjZG8g",
        });

        if (responseParticipants.statusCode == 200) {
          participantBox.deleteAll(participantBox.keys);
          (json.decode(responseParticipants.body)["results"] as List)
              .map((signataireJson) async {
            var ln = participantBox.values
                .where((object) => object['id'] == signataireJson['id'])
                .toList()
                .length;
            if (ln == 0) {
              await participantBox.add(signataireJson);
            }
            signataireJson = {};
          }).toList();
        } else {
          print('echec');
        }

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
        }
      } else {
        print('pas de connexion else');
      }
    } on SocketException catch (_) {
      print('pas de connexion');
    }
    List edls = edlBox.values.toList();

    _etat = [];
    edls.forEach((usersJson) async {
      List total = await getSignatairesEdl(usersJson['_id']);
      _etat.add(EtatRealisation(
          nbrecom: usersJson['logement']['client']['nom'],
          titre: "EDL " +
              (usersJson['type_edl'] == null ? "" : usersJson['type_edl']),
          numero: "",
          rue: usersJson['logement']['ville'] +
              ", Secteur: " +
              usersJson['logement']['secteur'] +
              ", B.P:" +
              usersJson['logement']['postal_code'],
          edl: usersJson['type_edl'] == null
              ? ""
              : usersJson['type_edl'].toString().toUpperCase(),
          etat: usersJson['avancement'] == null ? "" : usersJson['avancement'],
          description: usersJson['logement']['type_log']['nom'],
          participant: (total.length).toString(),
          pieces: "salut",
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

  bool checkImageExist(String path) {
    File file = File(path);
    if (file.existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future validateEdl(idEdl) async {
    dynamic edl = await getSingleEdl(idEdl.toString());
    Uri editEdlRoad = Uri(
        scheme: "http",
        host: "195.15.218.172",
        path: "edlgateway/api/v1/participant/all",
        query: "start=1&limit=1&count=10");
    //creation de la requette
    var request = http.MultipartRequest('PUT', editEdlRoad);
    //ajout de l'EDL
    request.fields['json'] = json.encode(edl);
    //ajout des images compteur
    edl["logement"]['type_log']['compteur'].forEach((key, value) async {
      int i = 1;
      for (i = 1; i <= 3; i++) {
        if (checkImageExist(value['image' + i.toString()].toString())) {
          var file = await http.MultipartFile.fromPath(
              'image', value['image' + i.toString()].toString(),
              contentType: MediaType('image', 'jpeg'),
              filename: key.toString());
          request.files.add(file);
        }
      }
    });
    //ajout des images cles
    edl["logement"]['type_log']['cles'].forEach((key, value) async {
      int i = 1;
      for (i = 1; i <= 3; i++) {
        if (checkImageExist(value['image' + i.toString()].toString())) {
          var file = await http.MultipartFile.fromPath(
              'image', value['image' + i.toString()].toString(),
              contentType: MediaType('image', 'jpeg'),
              filename: key.toString());
          request.files.add(file);
        }
      }
    });
    //ajout des images rubriques
    edl["logement"]['type_log']['piece'].forEach((key, value) {
      value['rubriq'].forEach((key1, value1) async {
        int i = 1;
        for (i = 1; i <= 3; i++) {
          if (checkImageExist(value['image' + i.toString()].toString())) {
            var file = await http.MultipartFile.fromPath(
                'image', value['image' + i.toString()].toString(),
                contentType: MediaType('image', 'jpeg'),
                filename: key.toString() + "_" + key1.toString());
            request.files.add(file);
          }
        }
      });
    });
    print(json.decode(request.fields['json']!)["logement"]['type_log']
        ['compteur']);
  }

  Future getParticipantsClient(idClient) async {
    var participantBox = await Hive.openBox<dynamic>("participant");
    this._participantClient = [];
    List liste = participantBox.values
        .toList()
        .where((edl) => edl["compte_client"]['_id'] == idClient)
        .toList();
    if (liste != null) {
      liste.forEach((value) {
        this._participantClient.add(value);
        value = {};
      });
      notifyListeners();
    }
    return _participantClient;
  }

  getSingleEdl(String id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    return edlBox.values.toList().where((edl) => edl["_id"] == id).toList()[0];
  }

  getSingleEdlData(id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    dynamic edl =
        edlBox.values.toList().where((edl) => edl["_id"] == id).toList()[0];
    List pieces_ = await this.getSpecificEDL(id.toString());
    List clefs_ = await this.getClef(id);
    List compturs_ = await this.getCompteur(id);
    return {
      "pieces": pieces_.length.toString(),
      "cles": clefs_.length.toString(),
      "compteurs": compturs_.length.toString(),
      "adresse": edl['logement']['ville'].toString() +
          ", Secteur: " +
          edl['logement']['secteur'].toString() +
          " Code Postal: " +
          edl['logement']['postal_code'].toString()
    };
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
    if (piece != null) {
      piece['rubriq'].forEach((key, value) {
        if (key.toString() != "rubriques") {
          value["key"] = key.toString();
          value['value'] = value['_id'];
          this._rubriques.add(value);
        }
      });
    }

    notifyListeners();
    return _rubriques;
  }

  getCompteur(_id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    this._compteurs = [];
    List liste =
        edlBox.values.toList().where((edl) => edl["_id"] == _id).toList();

    if (liste.isEmpty == false) {
      var edl = liste[0];
      edl['logement']['type_log']['compteur'].forEach((key, value) {
        value["key"] = key.toString();
        this._compteurs.add(value);
        value = {};
      });
      notifyListeners();
    }

    return _compteurs;
  }

  getClef(_id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    this._clefs = [];
    List liste =
        edlBox.values.toList().where((edl) => edl["_id"] == _id).toList();
    if (liste.isEmpty == false) {
      var piece = liste[0];
      piece['logement']['type_log']['cles'].forEach((key, value) {
        value["key"] = key.toString();
        this._clefs.add(value);
        value = {};
      });
      notifyListeners();
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
      String img3,
      String temp1,
      String temp2,
      String temp3) async {
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
            valueR['tempsImage1'] = temp1;
            valueR['tempsImage2'] = temp2;
            valueR['tempsImage3'] = temp3;
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

  constatClef(
      String idEdl,
      String idCles,
      String etat,
      String remise,
      String rendus,
      String nombreFacture,
      String motif_facturation,
      String prix_ttc,
      String description,
      String commentaire,
      String commentaitreFinal,
      BuildContext context,
      String img1,
      String img2,
      String img3,
      String temp1,
      String temp2,
      String temp3) async {
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
    edl["logement"]['type_log']['cles'].forEach((key, value) {
      if (key == idCles) {
        value['etat'] = etat;
        value['description'] = description;
        value['commentaire'] = commentaire;
        value['remise'] = remise;
        value['rendus'] = rendus;
        value['nombreFacture'] = nombreFacture;
        value['motif_facturation'] = motif_facturation;
        value['prix_ttc'] = prix_ttc;
        value['commentaireFinal'] = commentaitreFinal;
        value['image1'] = img1;
        value['image2'] = img2;
        value['image3'] = img3;
        value['tempsImage1'] = temp1;
        value['tempsImage2'] = temp2;
        value['tempsImage3'] = temp3;
        value['constate'] = "ok";
        edl["logement"]['type_log']['cles'][key] = value;
        rubriqueFinale = value;
      }
    });
    await edlBox.putAt(index, edl);
    // ignore: use_build_context_synchronously
    displayDialog(context);
    return rubriqueFinale;
  }

  constatCompteur(
      String idEdl,
      String idCompteur,
      String etat,
      String indexActuel,
      String indexPrecedent,
      String anomaliecontroller,
      String commentaitreFinal,
      String commentaire,
      String description,
      BuildContext context,
      String img1,
      String img2,
      String img3,
      String temp1,
      String temp2,
      String temp3) async {
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
    edl['logement']['type_log']['compteur'].forEach((key, value) {
      if (key == idCompteur) {
        value['etat'] = etat;
        value['description'] = description;
        value['commentaire'] = commentaire;
        value['anomalie'] = anomaliecontroller;
        value['indexActuel'] = indexActuel;
        value['indexPrecedent'] = indexPrecedent;
        value['commentaireFinal'] = commentaitreFinal;
        value['image1'] = img1;
        value['image2'] = img2;
        value['image3'] = img3;
        value['tempsImage1'] = temp1;
        value['tempsImage2'] = temp2;
        value['tempsImage3'] = temp3;
        value['constate'] = "ok";
        edl['logement']['type_log']['compteur'][key] = value;
        rubriqueFinale = value;
      }
    });
    await edlBox.putAt(index, edl);
    // ignore: use_build_context_synchronously
    displayDialog(context);
    return rubriqueFinale;
  }

  void deleteFile(String filePath) {
    File file = File(filePath);

    // Check if the file exists
    if (file.existsSync()) {
      try {
        file.deleteSync();
        print('File deleted successfully');
      } catch (e) {
        print('Failed to delete the file: $e');
      }
    } else {
      print('File not found');
    }
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
      if (element["type"].toString().toLowerCase() ==
              typeCommentaire.toLowerCase() &&
          element["key_"] == "autres") {
        final_.add(element);
        element = {};
      }
      if (element["type"].toString().toLowerCase() ==
              typeCommentaire.toLowerCase() &&
          element["key_"] == "autre") {
        final_.add(element);
        element = {};
      }
      if (element["type"].toString().toLowerCase() ==
              typeCommentaire.toLowerCase() &&
          element["key_"].toString() == "null") {
        final_.add(element);
        element = {};
      }
    });
    return final_;
  }

  getSignatairesEdl(_id) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    this._signataires = [];
    List liste =
        edlBox.values.toList().where((edl) => edl["_id"] == _id).toList();
    if (liste.isEmpty == false) {
      var edl = liste[0];
      edl['signataires'].forEach((key, value) {
        if (value != null) {
          value["key"] = key.toString();
          this._signataires.add(value);
          value = {};
        }
      });
      notifyListeners();
    }
    return _signataires;
  }

  checkEdlConstatEnd(_id) async {
    List pieces_ = await this.getSpecificEDL(_id.toString());
    List clefs_ = await this.getClef(_id);
    List compturs_ = await this.getCompteur(_id);
    bool consta = true;
    pieces_.forEach((element) {
      if (element['constate'] != "oui") {
        consta = false;
      }
    });
    clefs_.forEach((element) {
      if (element['constate'] == null) {
        consta = false;
      }
    });
    compturs_.forEach((element) {
      if (element['constate'] == null) {
        consta = false;
      }
    });
    return consta;
  }

  void addSignatureSignatairesEdl(
      _id, String idSigantaire, String path, String paraphe,
      {dynamic points = null}) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    int i = edlBox.values.length;
    var edl1;
    int index = 0;

    var edl = edlBox.values.firstWhere((object) {
      return object['_id'] == _id;
    });
    for (int k = 0; k <= i - 1; k++) {
      edl1 = edlBox.getAt(k);
      if (edl1['_id'] == _id) {
        index = k;
      }
    }
    edl['signataires'].forEach((key, value) {
      if (value != null && value['id'] == idSigantaire) {
        value["signature"] = path;
        value["paraphe"] = paraphe;
        //value["point"] = points;
        edl['signataires'][key] = value;
        if (points != null) {
          value['point'] = points;
        } else {
          value['point'] = null;
        }
      }
    });
    await edlBox.putAt(index, edl);
  }

  void eraseSignatureSignatairesEdl(_id, idSigantaire) async {
    var edlBox = await Hive.openBox<dynamic>("edl");
    int i = edlBox.values.length;
    var edl1;
    int index = 0;

    var edl = edlBox.values.firstWhere((object) {
      return object['_id'] == _id;
    });
    for (int k = 0; k <= i - 1; k++) {
      edl1 = edlBox.getAt(k);
      if (edl1['_id'] == _id) {
        index = k;
      }
    }
    edl['signataires'].forEach((key, value) {
      if (value != null && value['id'] == idSigantaire) {
        value['point'] = null;
      }
    });
    await edlBox.putAt(index, edl);
  }
}

ShowDialogwidget(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Text("Pas de connexion internet"),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("ok"),
      ),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
