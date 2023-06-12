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
  late PDFViewController _pdfViewController;
  String idEdl = "";
  dynamic edl = {};
  EtatRealisationProvider etatRealisationProvider = EtatRealisationProvider();
  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {
      var id = globals.getString("edlId");
      if (id != null) {
        idEdl = id;
        Future res = etatRealisationProvider.getSingleEdl(idEdl);
        res.then((value) => edl = value);
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

  Future<void> generatePdf() async {
    final pdf = pw.Document();
    var Image;
    var ImageSource = await rootBundle.load('assets/img/logo.png');
    Image = ImageSource.buffer.asUint8List();
    pdf.addPage(pw.Page(
        margin: pw.EdgeInsets.fromLTRB(20, -1, 20, -1),
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          List<pw.TableRow> signataires = [];
          edl['signataires'].forEach((key, value) {
            String ref = "RAS";
            if (value['reference'] != null) {
              ref = value['reference'];
            }
            signataires.add(pw.TableRow(children: [
              pw.Text(
                "${value['prenom']} ${value['nom']}",
                style: const pw.TextStyle(fontSize: 15),
              ),
              pw.SizedBox(
                width: 20,
              ),
              pw.Text(
                value['role'].toString(),
                style: pw.TextStyle(fontSize: 15),
              ),
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
          });
          return pw.Stack(
            // margin: const pw.EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 15.0),
            // padding: const pw.EdgeInsets.all(10),
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
                              "${edl['user']['nom'].toString().toUpperCase()}  ${edl['user']['prenom'].toString().toUpperCase()}",
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
                          bottom: pw.BorderSide(width: 1)),
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
                                edl['logement']['Meuble'],
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
                          bottom: pw.BorderSide(width: 1)),
                      children: [
                        pw.TableRow(
                            decoration: const pw.BoxDecoration(
                                color: PdfColors.amber600),
                            children: [
                              pw.Text(
                                '  Nom  '.toUpperCase(),
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(
                                width: 45,
                              ),
                              pw.Text(
                                '  Role  '.toUpperCase(),
                                style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold),
                              ),
                              pw.SizedBox(
                                width: 45,
                              ),
                              pw.Text(
                                '  Informations  '.toUpperCase(),
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
          );
        }));

    pdf.addPage(
      pw.MultiPage(
        margin: pw.EdgeInsets.fromLTRB(20, -1, 20, -1),
        pageFormat: PdfPageFormat.a4,
        header: (pw.Context context) {
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
                                  edl['date_edl'].toString() +
                                  " à: " +
                                  edl['heure'].toString() +
                                  " par " +
                                  edl['user']['prenom']
                                      .toString()
                                      .toUpperCase() +
                                  " " +
                                  edl['user']['nom'].toString().toUpperCase(),
                              style: pw.TextStyle(fontSize: 10),
                              textAlign: pw.TextAlign.right),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Text(
                              'En présence de: ${edl['user']['prenom'].toString().toUpperCase()}',
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
            child: pw.Text(
                'Edele, version 5.1.0.6  Page: ' + _currentPage.toString(),
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
                      "Piece: " + value["nom"],
                      style: pw.TextStyle(
                          fontSize: 15, fontWeight: pw.FontWeight.bold),
                    ),
                  ]));
            }
            value['rubriq'].forEach((key, value) async {
              if (value["constate"] != null) {
                List<pw.Widget> chidrens = [
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
                  pw.SizedBox(
                    width: 10,
                  ),
                ];
                if (value['image2'] != null) {
                  try {
                    chidrens.add(pw.Positioned(
                      top: 0,
                      left: 0,
                      child: pw.Image(
                          pw.ImageProxy(PdfImage.file(
                            pdf.document,
                            bytes: File(value['image2']).readAsBytesSync(),
                          )),
                          height: 80,
                          width: 80),
                    ));
                    chidrens.add(pw.SizedBox(
                      width: 10,
                    ));
                  } catch (Exception) {}
                }
                if (value['image3'] != null) {
                  try {
                    chidrens.add(pw.Positioned(
                      top: 0,
                      left: 0,
                      child: pw.Image(
                          pw.ImageProxy(PdfImage.file(
                            pdf.document,
                            bytes: File(value['image3']).readAsBytesSync(),
                          )),
                          height: 80,
                          width: 80),
                    ));
                    chidrens.add(pw.SizedBox(
                      width: 10,
                    ));
                  } catch (Exceptio) {}
                }
                rubriques.add(pw.TableRow(children: [
                  pw.Wrap(children: [
                    pw.Text(
                      "${value['nom']}",
                      style: const pw.TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    pw.Row(children: chidrens),
                  ]),
                  pw.SizedBox(
                    width: 20,
                  ),
                  pw.SizedBox(
                    width: 90,
                    child: pw.Text(
                      value['etat'].toString(),
                      style: pw.TextStyle(fontSize: 15),
                    ),
                  ),
                  pw.SizedBox(
                    width: 20,
                  ),
                  pw.Text(
                    value['commentaireFinal'].toString(),
                    style: pw.TextStyle(fontSize: 15),
                  )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Prévisualisation du PDF'),
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
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      _currentPage = page!;
                    });
                  },
                  onPageError: (page, error) {
                    // Handle page error
                  },
                ),
        ));
  }
}
