/*import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as pwWidgets;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_preview/pdf_preview.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  final pdf = pw.Document();

  void generatePDF() {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            child: pwWidgets.Table.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Name', 'Age', 'City'],
                <String>['John Doe', '30', 'New York'],
                <String>['Jane Smith', '25', 'London'],
                <String>['Bob Johnson', '40', 'Paris'],
              ],
            ),
          );
        },
      ),
    );

    final file = File('example.pdf');
    file.writeAsBytesSync(pdf.save() as List<int>);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () => generatePDF(),
              child: Text('Generate PDF'),
            ),
            SizedBox(height: 16),
            RaisedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PDFView(
                    pdf: pdf.save(),
                    canChangeOrientation: true,
                    canChangePageFormat: true,
                  ),
                ),
              ),
              child: Text('Preview PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
*/