import 'dart:io';

import 'package:ams_mobile/providers/etat_realisation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfViewerPage extends StatefulWidget {
  @override
  _PdfViewerPageState createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  late SharedPreferences globals;
  int _totalPages = 0;
  int _currentPage = 0;
  int pages = 0;
  late PDFViewController _pdfViewController;
  String idEdl = "";
  dynamic edl = {};
  dynamic signataires = {};
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      var id = globals.getString("edlId");
      if (id != null) {
        idEdl = id;
        Future res = etatRealisationProvider.getSingleEdl(idEdl);
        res.then((value) => edl = value);
        Future res1 = etatRealisationProvider.getSignatairesEdl(idEdl);
        res1.then((value) => signataires = value);
      }
    });
  }

  String pdfPath = '';

  @override
  void initState() {
    super.initState();
    initSharedPref();
    generatePdf();
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
    return day1 + "/" + month1 + "/" + year + " à " + heure + ":" + minute;
  }

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    var Image;
    var ImageSource = await rootBundle.load('assets/img/logo.png');
    Image = ImageSource.buffer.asUint8List();
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.fromLTRB(20, -1, 20, -1),
        pageFormat: PdfPageFormat.a4,
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: pw.EdgeInsets.only(top: 20),
            child: pw.Text('Edele, version 5  Page: ${pages.toString()}',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          );
        },
        build: (pw.Context context) {
          List<pw.TableRow> signataires = [];
          dynamic client = edl['logement']['client'];
          signataires.add(pw.TableRow(children: [
            pw.SizedBox(
              width: 200,
              child: pw.Text(
                "${client['nom']}",
                style: const pw.TextStyle(fontSize: 15),
              ),
            ),
            pw.SizedBox(
              width: 10,
            ),
            pw.SizedBox(
              width: 150,
              child: pw.Text(
                "Bailleur/Donneur d'ordre",
                style: pw.TextStyle(fontSize: 15),
              ),
            ),
            pw.SizedBox(
              width: 20,
            ),
            pw.Text(
              "",
              style: pw.TextStyle(fontSize: 15),
            ),
          ]));
          edl['signataires'].forEach((key, value) {
            String ref = "RAS";
            if (value != null) {
              if (value['reference'] != null) {
                ref = value['reference'];
              }
              signataires.add(pw.TableRow(children: [
                pw.SizedBox(
                    width: 200,
                    child: pw.Text(
                      "${value['prenom']} ${value['nom']}",
                      style: const pw.TextStyle(fontSize: 15),
                    )),
                pw.SizedBox(
                  width: 10,
                ),
                pw.SizedBox(
                    width: 150,
                    child: pw.Text(
                      value['role'].toString(),
                      style: pw.TextStyle(fontSize: 15),
                    )),
                pw.SizedBox(
                  width: 20,
                ),
                pw.Text(
                  'tel: ' +
                      value['telephone'].toString() +
                      "\nemail: " +
                      value['email'].toString() +
                      "\nReference: " +
                      ref,
                  style: pw.TextStyle(fontSize: 15),
                ),
              ]));

              value = {};
            }
          });
          return [
            pw.Stack(
              // margin: const pw.EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
              //padding: const pw.EdgeInsets.all(10),
              children: [
                pw.ListView(children: [
                  pw.Row(children: [
                    pw.Positioned(
                      top: 0,
                      left: 0,
                      child: pw.Image(pw.MemoryImage(Image as Uint8List),
                          height: 100, width: 100),
                    ),
                    pw.SizedBox(
                      height: 20,
                      width: 15,
                    ),
                    pw.Table(
                        border: pw.TableBorder(
                            top: pw.BorderSide(width: 1),
                            bottom: pw.BorderSide(width: 1)),
                        children: [
                          pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.amber600),
                              children: [
                                pw.Text('TRUSEXPERTISE',
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.TableRow(children: [
                            pw.Text(
                                'AMEXPERT-CONSTATS D\'HABITAT \n25 STATION ROAD \nB14 7SR Birmingham UK',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                          ]),
                        ]),
                    pw.SizedBox(
                      height: 20,
                      width: 110,
                    ),
                    pw.Table(
                        border: pw.TableBorder(
                            top: pw.BorderSide(width: 1),
                            bottom: pw.BorderSide(width: 1)),
                        children: [
                          pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.amber600),
                              children: [
                                pw.Text(
                                    "EDL ${edl['type_edl'].toString().toUpperCase()}",
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.TableRow(children: [
                            pw.Text('Rédaction du constats pour les parties',
                                style: pw.TextStyle(fontSize: 10)),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                                'Le ${edl['date_edl'].toString().toUpperCase()} à ${edl['heure'].toString().toUpperCase()}\n EDL N° Num_EDL',
                                style: pw.TextStyle(
                                  fontSize: 10,
                                )),
                          ]),
                        ]),
                    pw.SizedBox(
                      height: 40,
                      width: 15,
                    ),
                  ]),
                  pw.SizedBox(
                    height: 25,
                    width: 10,
                  ),
                  pw.Wrap(children: [
                    pw.Table(
                        border: pw.TableBorder(
                            top: pw.BorderSide(width: 1),
                            bottom: pw.BorderSide(width: 1)),
                        children: [
                          pw.TableRow(children: [
                            pw.Expanded(
                                child: pw.Text(
                                    'Le présent constat est établi sur ordre de mission, par l\'expert',
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                    ))),
                          ]),
                          pw.TableRow(children: [
                            pw.Text(
                                "${edl['created_by']['nom'].toString().toUpperCase()}  ${edl['created_by']['prenom'].toString().toUpperCase()}",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                          ]),
                        ]),
                  ]),
                  pw.SizedBox(
                    height: 30,
                    width: 15,
                  ),
                  pw.Wrap(children: [
                    pw.Table(
                        border: pw.TableBorder(
                          top: pw.BorderSide(width: 1),
                          bottom: pw.BorderSide(width: 1),
                        ),
                        children: [
                          pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.amber600),
                              children: [
                                pw.Text('LOGEMENT',
                                    style: pw.TextStyle(
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold)),
                              ]),
                          pw.TableRow(children: [
                            pw.Text(
                                "${edl['logement']['ville'].toString().toUpperCase()} ${edl['logement']['secteur'].toString().toUpperCase()}",
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    fontWeight: pw.FontWeight.bold)),
                          ]),
                          pw.TableRow(children: [
                            pw.Table(children: [
                              pw.TableRow(children: [
                                pw.Text('Code lot: '),
                                pw.Text("",
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text(
                                  'Type de logement: ',
                                ),
                                pw.Text(
                                    edl['logement']['type_log']['nom']
                                        .toString()
                                        .toUpperCase(),
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    )),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text('Surface: '),
                                pw.Text(
                                  edl['logement']['surface'],
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                )
                              ]),
                              pw.TableRow(children: [
                                pw.Text('Ref commande: '),
                                pw.Text(
                                  'Ref commande',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text(
                                  'Meublé: ',
                                ),
                                pw.Text(
                                  edl['logement']['Meuble'].toString(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text('N° étage: '),
                                pw.Text(
                                  edl['logement']['nbre_etage'].toString(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                )
                              ]),
                              pw.TableRow(children: [
                                pw.Text('Ref lot client: '),
                                pw.Text(
                                  'Ref lot client',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text(
                                  'Code-Fact: ',
                                ),
                                pw.Text(
                                  edl['logement']['Code_fact'].toString(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text('N° porte: '),
                                pw.Text(
                                  edl['logement']['Num_porte'].toString(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                )
                              ]),
                              pw.TableRow(children: [
                                pw.Text('Autre: '),
                                pw.Text(
                                  edl['logement']['Autre'].toString(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text('Parking: '),
                                pw.Text(
                                  edl['logement']['paking'].toString(),
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                                pw.SizedBox(
                                  width: 20,
                                ),
                                pw.Text('Cave: '),
                                pw.Text(edl['logement']['cave'].toString(),
                                    style: pw.TextStyle(
                                        fontSize: 10,
                                        fontWeight: pw.FontWeight.bold),
                                    textAlign: pw.TextAlign.center)
                              ])
                            ])
                          ]),
                        ]),
                  ]),
                  pw.SizedBox(
                    height: 40,
                    width: 15,
                  ),
                  pw.Wrap(children: [
                    pw.Table(
                        border: pw.TableBorder(
                          top: pw.BorderSide(width: 1),
                          bottom: pw.BorderSide(width: 1),
                        ),
                        children: [
                          pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.amber600),
                              children: [
                                pw.SizedBox(
                                    width: 200,
                                    child: pw.Text(
                                      'Nom  '.toUpperCase(),
                                      style: pw.TextStyle(
                                          fontSize: 20,
                                          fontWeight: pw.FontWeight.bold),
                                    )),
                                pw.SizedBox(
                                    width: 150,
                                    child: pw.Text(
                                      'Role  '.toUpperCase(),
                                      style: pw.TextStyle(
                                          fontSize: 20,
                                          fontWeight: pw.FontWeight.bold),
                                    )),
                                pw.Text(
                                  'Informations  '.toUpperCase(),
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ]),
                        ]),
                    pw.Table(
                        border: pw.TableBorder(
                          top: pw.BorderSide(width: 1),
                          bottom: pw.BorderSide(width: 1),
                          horizontalInside: pw.BorderSide(width: 1),
                        ),
                        children: signataires),
                  ]),
                  pw.SizedBox(
                    height: 40,
                    width: 15,
                  ),
                  pw.Wrap(children: [
                    pw.Table(
                        border: pw.TableBorder(
                          top: pw.BorderSide(width: 1),
                          bottom: pw.BorderSide(width: 1),
                        ),
                        children: [
                          pw.TableRow(
                              decoration: const pw.BoxDecoration(
                                  color: PdfColors.amber600),
                              children: [
                                pw.Text(
                                  'informations administratives'
                                      .toString()
                                      .toUpperCase(),
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold),
                                )
                              ]),
                          pw.TableRow(children: [
                            pw.Text(
                                "Entré le: ${edl["date_entree"]}      sortie le: ${edl["date_sortie"]}\nDate Etat de lieu entrant: ${edl["date_edl"]}\nNouvelle adresse: ")
                          ])
                        ])
                  ])
                ]),
              ],
            )
          ];
        }));

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.fromLTRB(20, -1, 20, -1),
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          pages++;
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: pw.EdgeInsets.only(bottom: 20),
            child: pw.ListView(
              children: [
                pw.Row(children: [
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('trustexpertise'.toUpperCase(),
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text('Code lot: ',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text('EDL N°: ',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 20,
                    width: 220,
                  ),
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('Edition du '.toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              "EDL " + edl['type_edl'].toString().toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'Etabli le: ' +
                                  TraitementDate() +
                                  " par " +
                                  edl['created_by']['prenom']
                                      .toString()
                                      .toUpperCase() +
                                  " " +
                                  edl['created_by']['nom']
                                      .toString()
                                      .toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'En présence de: ${edl['created_by']['prenom'].toString().toUpperCase()}',
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: pw.EdgeInsets.only(top: 20),
            child: pw.Text('Edele, version 5  Page: ${pages.toString()}',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          );
        },
        build: (pw.Context context) {
          List<pw.TableRow> rubriques = [];
          edl['logement']['type_log']['piece'].forEach((key, value) {
            bool constate = false;
            value['rubriq'].forEach((key, value) {
              if (value["constate"] != null) {
                constate = true;
              }
            });
            if (constate == true) {
              rubriques.add(pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.amber600),
                  children: [
                    pw.Text(
                      "Piece: " + value["nom"].toString(),
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold),
                    ),
                  ]));
            }
            value['rubriq'].forEach((key, value) async {
              if (value["constate"] != null) {
                File file = File(value['image1'].toString());
                List<pw.Widget> chidrens = [];
                if (file.existsSync()) {
                  chidrens.add(
                    pw.Wrap(
                      children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image1']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage1'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ]),
                      ],
                    ),
                  );
                  chidrens.add(pw.SizedBox(
                    width: 10,
                  ));
                  ;
                }
                if (value['image2'] != null) {
                  try {
                    chidrens.add(
                      pw.Wrap(children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image2']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage2'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ])
                      ]),
                    );
                    chidrens.add(pw.SizedBox(
                      width: 10,
                    ));
                  } catch (Exception) {}
                }
                if (value['image3'] != null) {
                  try {
                    chidrens.add(
                      pw.Wrap(children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image3']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage3'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ]),
                      ]),
                    );
                    chidrens.add(pw.SizedBox(
                      width: 5,
                    ));
                  } catch (Exceptio) {}
                }
                rubriques.add(pw.TableRow(children: [
                  pw.Wrap(children: [
                    pw.Text(
                      "${value['nom'].toString()}",
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Row(children: chidrens),
                  ]),
                  pw.Wrap(children: [
                    pw.SizedBox(
                      width: 5,
                    ),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        value['etat'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.SizedBox(
                        width: 110,
                        child: pw.Text(
                          value['commentaireFinal'].toString(),
                          style: pw.TextStyle(fontSize: 15),
                        )),
                  ]),
                ]));
                rubriques.add(pw.TableRow(children: [
                  pw.SizedBox(
                    height: 10,
                  )
                ]));
                value = {};
              }
            });
          });
          return [
            pw.Center(
              child: pw.Table(
                border: pw.TableBorder(
                    top: pw.BorderSide(width: 1),
                    bottom: pw.BorderSide(width: 1)),
                children: rubriques,
              ),
            )
          ];
        },
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.fromLTRB(20, -1, 20, -1),
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          pages++;
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: pw.EdgeInsets.only(bottom: 20),
            child: pw.ListView(
              children: [
                pw.Row(children: [
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('trustexpertise'.toUpperCase(),
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text('Code lot: ',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text('EDL N°: ',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 20,
                    width: 220,
                  ),
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('Edition du '.toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              "EDL " + edl['type_edl'].toString().toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'Etabli le: ' +
                                  TraitementDate() +
                                  " par " +
                                  edl['created_by']['prenom']
                                      .toString()
                                      .toUpperCase() +
                                  " " +
                                  edl['created_by']['nom']
                                      .toString()
                                      .toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'En présence de: ${edl['created_by']['prenom'].toString().toUpperCase()}',
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: pw.EdgeInsets.only(top: 20),
            child: pw.Text('Edele, version 5  Page: ${pages.toString()}',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          );
        },
        build: (pw.Context context) {
          List<pw.TableRow> rubriques = [];
          rubriques.add(pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.amber600),
              children: [
                pw.Text(
                  "Description des clés",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
              ]));
          rubriques.add(pw.TableRow(children: [
            pw.Wrap(children: [
              pw.Row(children: [
                pw.SizedBox(
                  width: 180,
                  child: pw.Text(
                    "Clés",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.SizedBox(
                  width: 60,
                  child: pw.Text(
                    "Remise",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.SizedBox(
                  width: 50,
                  child: pw.Text(
                    "Rendu",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(
                  width: 5,
                ),
                pw.SizedBox(
                  width: 230,
                  child: pw.Text(
                    "Observation",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ]),
            ]),
          ]));
          edl['logement']['type_log']['cles'].forEach((key, value) {
            if (value["constate"] != null) {
              List<pw.Widget> chidrens = [
                pw.Wrap(
                  children: [
                    pw.SizedBox(
                      width: 180,
                      child: pw.Text(
                        value['nom'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 20,
                    ),
                    pw.SizedBox(
                      width: 60,
                      child: pw.Text(
                        value['remise'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 20,
                    ),
                    pw.SizedBox(
                      width: 50,
                      child: pw.Text(
                        value['rendus'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 5,
                    ),
                    pw.SizedBox(
                      width: 230,
                      child: pw.Text(
                        value['commentaireFinal'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ];
              rubriques.add(pw.TableRow(children: [
                pw.Wrap(children: [
                  pw.Row(children: chidrens),
                ]),
              ]));
              rubriques.add(pw.TableRow(children: [
                pw.SizedBox(
                  height: 10,
                )
              ]));

              value = {};
            }
          });
          rubriques.add(pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.amber600),
              children: [
                pw.Text(
                  "Synthèse des clés",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 0),
              ]));
          rubriques.add(pw.TableRow(children: [
            pw.SizedBox(height: 10),
          ]));

          List<pw.Widget> chidrens = [];
          edl['logement']['type_log']['cles'].forEach((key, value) {
            if (value["constate"] != null) {
              File file = File(value['image1'].toString());
              if (file.existsSync()) {
                chidrens.add(pw.Wrap(
                  children: [
                    pw.Column(children: [
                      pw.Positioned(
                        top: 0,
                        left: 0,
                        child: pw.Image(
                            pw.ImageProxy(PdfImage.file(
                              pdf.document,
                              bytes: File(value['image1']).readAsBytesSync(),
                            )),
                            height: 80,
                            width: 80),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "${value['tempsImage1'].toString()}",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ]),
                  ],
                ));
              }
              chidrens.add(
                pw.SizedBox(
                  width: 10,
                ),
              );
              if (value['image2'] != null) {
                File file = File(value['image2'].toString());
                if (file.existsSync()) {
                  try {
                    chidrens.add(
                      pw.Wrap(children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image2']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage2'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ])
                      ]),
                    );
                    chidrens.add(pw.SizedBox(
                      width: 10,
                    ));
                  } catch (Exception) {}
                }
              }
              if (value['image3'] != null) {
                File file = File(value['image3'].toString());
                if (file.existsSync()) {
                  try {
                    chidrens.add(
                      pw.Wrap(children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image3']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage3'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ]),
                      ]),
                    );
                    chidrens.add(pw.SizedBox(
                      width: 5,
                    ));
                  } catch (Exceptio) {}
                }
              }
              if (chidrens.length >= 12) {
                rubriques.add(pw.TableRow(children: [
                  pw.Wrap(children: [
                    pw.Row(children: chidrens),
                  ]),
                ]));
                rubriques.add(pw.TableRow(children: [
                  pw.SizedBox(
                    height: 10,
                  )
                ]));
                chidrens = [];
              }
              value = {};
            }
          });
          if (chidrens.length != 0) {
            rubriques.add(pw.TableRow(children: [
              pw.Wrap(children: [
                pw.Row(children: chidrens),
              ]),
            ]));
            rubriques.add(pw.TableRow(children: [
              pw.SizedBox(
                height: 10,
              )
            ]));
          }

          // Description des compteurs

          rubriques.add(pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.amber600),
              children: [
                pw.Text(
                  "Description des Compteurs",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
              ]));

          rubriques.add(pw.TableRow(children: [
            pw.Wrap(children: [
              pw.Row(children: [
                pw.SizedBox(
                  width: 180,
                  child: pw.Text(
                    "Compteur",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.SizedBox(
                  width: 75,
                  child: pw.Text(
                    "Ancien Index",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(
                  width: 20,
                ),
                pw.SizedBox(
                  width: 75,
                  child: pw.Text(
                    "Index Actuel",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                pw.SizedBox(
                  width: 5,
                ),
                pw.SizedBox(
                  width: 210,
                  child: pw.Text(
                    "Matricule",
                    style: pw.TextStyle(
                        fontSize: 15, fontWeight: pw.FontWeight.bold),
                  ),
                ),
              ]),
            ]),
          ]));

          edl['logement']['type_log']['compteur'].forEach((key, value) {
            if (value["constate"] != null) {
              List<pw.Widget> chidrens = [
                pw.Wrap(
                  children: [
                    pw.SizedBox(
                      width: 180,
                      child: pw.Text(
                        value['nom'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 20,
                    ),
                    pw.SizedBox(
                      width: 75,
                      child: pw.Text(
                        value['indexPrecedent'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 20,
                    ),
                    pw.SizedBox(
                      width: 75,
                      child: pw.Text(
                        value['indexActuel'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                    pw.SizedBox(
                      width: 5,
                    ),
                    pw.SizedBox(
                      width: 210,
                      child: pw.Text(
                        value['commentaireFinal'].toString(),
                        style: pw.TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ];
              rubriques.add(pw.TableRow(children: [
                pw.Wrap(children: [
                  pw.Row(children: chidrens),
                ]),
              ]));
              rubriques.add(pw.TableRow(children: [
                pw.SizedBox(
                  height: 10,
                )
              ]));

              value = {};
            }
          });

          rubriques.add(pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.amber600),
              children: [
                pw.Text(
                  "Synthèse des compteurs",
                  style: pw.TextStyle(
                      fontSize: 15, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 0),
              ]));
          rubriques.add(pw.TableRow(children: [
            pw.SizedBox(height: 10),
          ]));

          List<pw.Widget> chidrens1 = [];
          edl['logement']['type_log']['compteur'].forEach((key, value) {
            if (value["constate"] != null) {
              File file = File(value['image1'].toString());
              if (file.existsSync()) {
                chidrens1.add(pw.Wrap(
                  children: [
                    pw.Column(children: [
                      pw.Positioned(
                        top: 0,
                        left: 0,
                        child: pw.Image(
                            pw.ImageProxy(PdfImage.file(
                              pdf.document,
                              bytes: File(value['image1']).readAsBytesSync(),
                            )),
                            height: 80,
                            width: 80),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        "${value['tempsImage1'].toString()}",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ]),
                  ],
                ));
                chidrens1.add(
                  pw.SizedBox(
                    width: 10,
                  ),
                );
              }
              ;

              if (value['image2'] != null) {
                File file = File(value['image2'].toString());
                if (file.existsSync()) {
                  try {
                    chidrens1.add(
                      pw.Wrap(children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image2']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage2'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ])
                      ]),
                    );
                    chidrens1.add(pw.SizedBox(
                      width: 10,
                    ));
                  } catch (Exception) {}
                }
              }
              if (value['image3'] != null) {
                File file = File(value['image2'].toString());
                if (file.existsSync()) {
                  try {
                    chidrens1.add(
                      pw.Wrap(children: [
                        pw.Column(children: [
                          pw.Positioned(
                            top: 0,
                            left: 0,
                            child: pw.Image(
                                pw.ImageProxy(PdfImage.file(
                                  pdf.document,
                                  bytes:
                                      File(value['image3']).readAsBytesSync(),
                                )),
                                height: 80,
                                width: 80),
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text(
                            "${value['tempsImage3'].toString()}",
                            style: const pw.TextStyle(
                              fontSize: 8,
                            ),
                          ),
                        ]),
                      ]),
                    );
                    chidrens1.add(pw.SizedBox(
                      width: 5,
                    ));
                  } catch (Exceptio) {}
                }
              }
              if (chidrens1.length >= 12) {
                rubriques.add(pw.TableRow(children: [
                  pw.Wrap(children: [
                    pw.Row(children: chidrens1),
                  ]),
                ]));
                rubriques.add(pw.TableRow(children: [
                  pw.SizedBox(
                    height: 10,
                  )
                ]));
                chidrens1 = [];
              }
              value = {};
            }
          });
          if (chidrens1.length != 0) {
            rubriques.add(pw.TableRow(children: [
              pw.Wrap(children: [
                pw.Row(children: chidrens1),
              ]),
            ]));
            rubriques.add(pw.TableRow(children: [
              pw.SizedBox(
                height: 10,
              )
            ]));
          }
          return [
            pw.Center(
              child: pw.Table(
                border: pw.TableBorder(
                    top: pw.BorderSide(width: 1),
                    bottom: pw.BorderSide(width: 1)),
                children: rubriques,
              ),
            )
          ];
        },
      ),
    );

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.fromLTRB(20, -1, 20, -1),
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
          pages++;
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            margin: pw.EdgeInsets.only(bottom: 20),
            child: pw.ListView(
              children: [
                pw.Row(children: [
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('trustexpertise'.toUpperCase(),
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text('Code lot: ',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text('EDL N°: ',
                              style: pw.TextStyle(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 20,
                    width: 220,
                  ),
                  pw.Table(
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Text('Edition du '.toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              "EDL " + edl['type_edl'].toString().toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'Etabli le: ' +
                                  TraitementDate() +
                                  " par " +
                                  edl['created_by']['prenom']
                                      .toString()
                                      .toUpperCase() +
                                  " " +
                                  edl['created_by']['nom']
                                      .toString()
                                      .toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'En présence de: ${edl['created_by']['prenom'].toString().toUpperCase()}',
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: pw.EdgeInsets.only(top: 20),
            child: pw.Text('Edele, version 5  Page: ' + pages.toString(),
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          );
        },
        build: (pw.Context context) {
          List<pw.TableRow> rubriques = [];
          rubriques.add(pw.TableRow(children: [
            pw.Wrap(children: [
              pw.Row(children: [
                pw.Text(
                  "Approbation",
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ]),
            ]),
          ]));

          rubriques.add(pw.TableRow(children: [
            pw.Wrap(children: [
              pw.Container(
                child: pw.Text(
                  "Ce Constat d'Habitat atteste de l'état d'un lieu constaté par un expert au jour de sa réalisation. Il est exclusif de tout avis sur les" +
                      "conséquences de fait ou de droit pouvant en résulter, et peut-être attesté selon le NCPC, et connaissance prise des" +
                      "dispositions de l'article 161 du code pénal réprimant l'établissement de fausses attestations. Il est réalisé par un professionnel" +
                      "tiers de confiance dûment habilité par la certification AMEXPERT sous validité de deux ans, sans lien de subordination avec les" +
                      "parties. Son contenu peut également, s'il est signé contradictoirement attester d'un état des lieux selon Article 3-2 de la loi" +
                      "N°89-462. Constatation ou approbation du contenu présent. Je reconnais les points relevés sur le constat d'habitat dont je" +
                      "recevrai un original.",
                  style: pw.TextStyle(fontSize: 10),
                  softWrap: true,
                  textAlign: pw.TextAlign.justify,
                ),
              ),
            ]),
          ]));
          rubriques.add(pw.TableRow(children: [
            pw.Wrap(children: [
              pw.Container(
                child: pw.Text(
                  "Ce document est composé de ${pages.toString()} pages ",
                  style: pw.TextStyle(fontSize: 10),
                  softWrap: true,
                  textAlign: pw.TextAlign.justify,
                ),
              ),
            ]),
          ]));

          rubriques.add(pw.TableRow(children: [
            pw.SizedBox(height: 10),
          ]));
          List<pw.Widget> chidrens1 = [];

          signataires.map((e) {
            pw.Widget image = pw.SizedBox(height: 0, width: 0);
            pw.Widget paraphe = pw.SizedBox(height: 0, width: 0);
            if (e['signature'] != null) {
              paraphe = pw.SizedBox(
                  child: pw.Text(
                e['paraphe'].toString(),
                textAlign: pw.TextAlign.left,
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
              ));
              File file = File(e['signature'].toString());
              if (file.existsSync()) {
                try {
                  image = pw.Positioned(
                    top: 0,
                    left: 0,
                    child: pw.Image(
                        pw.ImageProxy(PdfImage.file(
                          pdf.document,
                          bytes: File(e['signature']).readAsBytesSync(),
                        )),
                        height: 30,
                        width: 30),
                  );
                } catch (Exceptio) {}
              }
              if (e['signature'].toString() == "Absent") {
                image = pw.SizedBox(
                    child: pw.Text(
                  "Absent",
                  textAlign: pw.TextAlign.left,
                  style: const pw.TextStyle(
                    fontSize: 12,
                  ),
                ));
              }
            }

            chidrens1.add(pw.Wrap(
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                          child: pw.Text(
                        "${e['role'].toString().toUpperCase()}",
                        textAlign: pw.TextAlign.left,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      )),
                      pw.SizedBox(width: 20),
                      pw.SizedBox(
                          child: pw.Text(
                        "Nom: ${e['nom'].toString()}  ${e['prenom'].toString()}",
                        textAlign: pw.TextAlign.left,
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      )),
                      pw.Row(children: [
                        pw.SizedBox(
                            child: pw.Text(
                          "Paraphe: ",
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        )),
                        pw.SizedBox(width: 10),
                        paraphe
                      ]),
                      pw.Row(children: [
                        pw.SizedBox(
                            child: pw.Text(
                          "Signature: ",
                          style: const pw.TextStyle(
                            fontSize: 12,
                          ),
                        )),
                        pw.SizedBox(width: 10),
                        image
                      ])
                    ]),
              ],
            ));

            chidrens1.add(
              pw.SizedBox(
                width: 10,
              ),
            );
          }).toList();
          rubriques.add(pw.TableRow(children: [
            pw.Wrap(children: [
              pw.Row(children: chidrens1),
            ]),
          ]));
          rubriques.add(pw.TableRow(children: [
            pw.SizedBox(
              height: 10,
            )
          ]));

          return [
            pw.Center(
              child: pw.Table(
                border: pw.TableBorder(
                    top: pw.BorderSide(width: 1),
                    bottom: pw.BorderSide(width: 1)),
                children: rubriques,
              ),
            )
          ];
        },
      ),
    );

    final pdfBytes = pdf.save();
    List<int> final_Doc = [];
    await pdfBytes.then((value) => final_Doc = value.cast<int>());
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/example.pdf';
    final pdfFile = File(tempPath);
    await pdfFile.writeAsBytes(final_Doc);

    setState(() {
      pdfPath = tempPath;
    });
  }

  bool signatureVisibility = false;
  @override
  Widget build(BuildContext context) {
    Future fini = Provider.of<EtatRealisationProvider>(context)
        .checkEdlConstatEnd(globals.getString("edlId"));
    fini.then((value) => signatureVisibility = value as bool);
    return Scaffold(
        appBar: AppBar(
          title: Text('Prévisualisation du PDF'),
          actions: [
            Visibility(
              visible: signatureVisibility,
              child: ElevatedButton.icon(
                onPressed: () async {
                  etatRealisationProvider
                      .validateEdl(globals.getString("edlId"));
                },
                label: Text(""),
                icon: Icon(Icons.save),
                /*style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Color.fromARGB(255, 8, 117, 243)),
              ),*/
              ),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: pdfPath.isEmpty
              ? Center(child: CircularProgressIndicator())
              : PDFView(
                  nightMode: false,
                  autoSpacing: false,
                  enableSwipe: true,
                  swipeHorizontal: true,
                  pageSnap: true,
                  filePath: pdfPath,
                  onViewCreated: (PDFViewController viewController) {
                    _pdfViewController = viewController;
                    _pdfViewController.getPageCount().then((count) {
                      setState(() {
                        _totalPages = count!;
                      });
                    });
                  },
                  onPageError: (page, error) {
                    // Handle page error
                  },
                ),
        ));
  }
}
