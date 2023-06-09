import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class camera extends StatefulWidget {
  camera({super.key});

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
    setState(() {
      img1 = globals.getString("urlImage1").toString();
      img2 = globals.getString("urlImage2").toString();
      img3 = globals.getString("urlImage3").toString();
    });
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

  Future<File> saveFilePermanently(String imagepath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagepath);
    final image = File('${directory.path}/$name');
    if (globals.getString("urlImage1").toString() == "") {
      globals.setString("urlImage1", image.path.toString());
      return File(imagepath).copy(image.path);
    }
    if (globals.getString("urlImage1").toString() != "" &&
        globals.getString("urlImage2").toString() == "") {
      globals.setString("urlImage2", image.path.toString());
      return File(imagepath).copy(image.path);
    }
    if (globals.getString("urlImage1").toString() != "" &&
        globals.getString("urlImage2").toString() != "" &&
        globals.getString("urlImage3").toString() == "") {
      globals.setString("urlImage3", image.path.toString());
      return File(imagepath).copy(image.path);
    }
    return File(imagepath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        getImage(ImageSource.camera);
      },
      icon: Icon(
        Icons.camera_alt,
        size: 30,
        color: Colors.white,
      ),
    );
  }
}
