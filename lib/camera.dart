import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class camera extends StatefulWidget {
  String cas = "";
  camera({super.key, cas});

  final _cameraState myAppState = new _cameraState();
  @override
  _cameraState createState() => _cameraState();
}

class _cameraState extends State<camera> {
  late SharedPreferences globals;
  File? _image;
  String img1 = "";
  String img2 = "";
  String img3 = "";

  void initSharedPref() async {
    globals = await SharedPreferences.getInstance();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  //fonction permettant de prendre une photo
  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      //final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Echec de la prise de photo: $e');
    }
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
    return day1 + "/" + month1 + "/" + year + " à " + heure + "h" + minute;
  }

  Future<File> saveFilePermanently(String imagepath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagepath);
    final image = File('${directory.path}/$name');

    if (globals.getString("urlImage1").toString() == "") {
      globals.setString("urlImage1", image.path.toString());
      globals.setString("tempsImage1", TraitementDate());
      return File(imagepath).copy(image.path);
    }
    if (globals.getString("urlImage1").toString() != "" &&
        globals.getString("urlImage2").toString() == "") {
      globals.setString("urlImage2", image.path.toString());
      globals.setString("tempsImage2", TraitementDate());
      return File(imagepath).copy(image.path);
    }
    if (globals.getString("urlImage1").toString() != "" &&
        globals.getString("urlImage2").toString() != "" &&
        globals.getString("urlImage3").toString() == "") {
      globals.setString("urlImage3", image.path.toString());
      globals.setString("tempsImage3", TraitementDate());
      return File(imagepath).copy(image.path);
    }

    return File(imagepath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
         style: ButtonStyle(
          padding: MaterialStateProperty.all(const EdgeInsets.only(right: 1.5)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          
           backgroundColor: MaterialStatePropertyAll<Color>(Colors.black),
           shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),)
         ),    
        onPressed: () {
          getImage(ImageSource.camera);
        },
       child: Center(
         child: Icon(
            Icons.camera_alt,
            size: 30,
            
            color: Colors.white,
          ),
       ),
      );
    
  }
}
