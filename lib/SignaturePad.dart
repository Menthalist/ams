import 'dart:typed_data';
import 'package:ams_mobile/camera.dart';
import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:ams_mobile/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'dart:io';

class SignaturePad extends StatefulWidget {
  dynamic e;
  SignaturePad({super.key, required this.e});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  Uint8List? exportedImage;
  TextEditingController parapheController = TextEditingController();
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  final _formkey = GlobalKey<FormState>();
  SignatureController _controller = SignatureController(
    penStrokeWidth: 5.0,
    penColor: Color.fromARGB(255, 5, 5, 5),
    exportBackgroundColor: Colors.white,
  );
  String idEdl = "";
  late SharedPreferences globals;

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();

    setState(() {
      idEdl = globals.getString("edlId").toString();
    });
  }

  dynamic serializePoint(Point p) {
    dynamic final_ = {};
    final_['offset'] = {"x": p.offset.dx, "y": p.offset.dy};
    final_["type"] = p.type.toString();
    final_["presure"] = p.pressure;
    return final_;
  }

  Point pointFromJson(dynamic din) {
    String type = din["type"].toString().split(".")[1].toString();
    PointType p = PointType.move;
    type.toLowerCase().removeAllWhitespace == "tap"
        ? p = PointType.tap
        : p = PointType.move;
    return Point(
        Offset(double.parse(din['offset']['x'].toString()),
            double.parse(din['offset']['y'].toString())),
        p,
        din['presure']);
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  String TraitementDate() {
    DateTime date1 = DateTime.now();
    String month1 = date1.month.toString().length > 1
        ? date1.month.toString()
        : "0" + date1.month.toString();
    String day1 = date1.day.toString().length > 1
        ? date1.day.toString()
        : "0" + date1.day.toString();
    String year = date1.year.toString();
    String heure = date1.hour.toString().length > 1
        ? date1.hour.toString()
        : "0" + date1.hour.toString();
    String minute = date1.minute.toString().length > 1
        ? date1.minute.toString()
        : "0" + date1.minute.toString();
    return day1 + "_" + month1 + "_" + year + "_" + heure + "h" + minute;
  }

  addSignataireDialog(BuildContext context, String texte) {
    AlertDialog alert = AlertDialog(
      content: Text(texte),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  ShowDialogield(BuildContext context, String texte) {
    AlertDialog alert = AlertDialog(
      content: Text(texte),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  ShowDialogDeleteSignataire(BuildContext context, String texte) {
    AlertDialog alert = AlertDialog(
      content: Text("Voulez vous vraiment supprimer ce signatire",
          style: TextStyle(
              fontFamily: "futura.LT",
              fontSize: 14,
              color: Color.fromARGB(255, 248, 3, 3))),
      actions: [
        TextButton(
          onPressed: () {
            etatRealisationProvider.deleteParticipant(
                globals.getString("edlId").toString(), widget.e['id']);
            Navigator.pop(context);
          },
          child: Text("Oui"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Non"),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.e['paraphe'] != null) {
      parapheController.text = widget.e['paraphe'].toString();
    }

    if (widget.e['point'] != null) {
      List<Point> points = [];
      widget.e['point'].forEach((key, value) {
        points.add(pointFromJson(value));
      });
      _controller = SignatureController(
          penStrokeWidth: 5.0,
          penColor: Color.fromARGB(255, 5, 5, 5),
          exportBackgroundColor: Colors.white,
          points: points);
    }

    return Column(children: [
      Signature(
        controller: _controller,
        height: MediaQuery.of(context).size.height * 0.14,
        width: MediaQuery.of(context).size.width * 0.92,
        backgroundColor: Color.fromRGBO(237, 237, 237, 1),
      ),
      Padding(padding: EdgeInsets.only(top: 10)),
      Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.05,
                margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                decoration: boxDecoration(
                    radius: 3,
                    colors: Colors.transparent,
                    taille: 1,
                    colorbordure: Colors.white),
                child: TextFormField(
                  controller: parapheController,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Paraphé',
                      labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'veillez remplir le champ';
                    }
                    return null;
                  },
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ShowDialogDeleteSignataire(context, "");
                      },
                      label: Text(""),
                      icon: Icon(Icons.close),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        etatRealisationProvider.eraseSignatureSignatairesEdl(
                            globals.getString("edlId").toString(),
                            widget.e['id']);
                        _controller.clear();
                      },
                      label: Text("Effacer"),
                      icon: Icon(Icons.delete),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _controller.clear();
                        Point point =
                            Point(Offset(12.0, 12.0), PointType.move, 0.1);
                        dynamic jsonPoin = serializePoint(point);
                        List<Point> signaturePoints = _controller.points;
                        etatRealisationProvider.addSignatureSignatairesEdl(
                            globals.getString("edlId").toString(),
                            widget.e['id'],
                            "Absent",
                            parapheController.text);
                        ShowDialogield(context,
                            "Signataire marqué comme absent avec succès");
                      },
                      label: Text("Absent"),
                      icon: Icon(Icons.assignment_late_outlined),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.black)),
                    ),
                  ),
                  /*Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.08,
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    child: Center(child: camera()),
                  ),*/
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (parapheController.text.isEmpty) {
                          ShowDialogield(
                              context, "Attention le paraphé est obligatoire");
                          return;
                        }
                        final Uint8List? signature =
                            await _controller.toPngBytes();
                        List<Point> signaturePoints = _controller.points;
                        dynamic pointsJson = {};
                        int i = 0;
                        signaturePoints.forEach((element) {
                          pointsJson[i.toString()] = serializePoint(element);
                          i++;
                        });

                        // Get the temporary directory path
                        final directory = await getTemporaryDirectory();
                        String nom = widget.e['nom']
                                .toString()
                                .removeAllWhitespace +
                            "_" +
                            widget.e['prenom'].toString().removeAllWhitespace +
                            TraitementDate();
                        final imagePath = '${directory.path}/$nom.png';

                        // Write the image data to a file
                        final File imageFile = File(imagePath);
                        await imageFile.writeAsBytes(signature!);
                        //print(widget.e);
                        etatRealisationProvider.addSignatureSignatairesEdl(
                            globals.getString("edlId").toString(),
                            widget.e['id'],
                            imagePath,
                            parapheController.text,
                            points: pointsJson);
                        ShowDialogield(
                            context, "Signature enregistré avec succès");
                        //_controller.clear();
                        //parapheController.text = "";
                      },
                      label: Text(""),
                      icon: Icon(Icons.save),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.red),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ))
    ]);
  }
}
