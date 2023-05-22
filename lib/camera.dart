import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class camera extends StatefulWidget {
  camera({super.key});

  final _cameraState myAppState = new _cameraState();
  @override
  _cameraState createState() => _cameraState();

  getCamera(BuildContext context) {
    myAppState.getCamera(context);
  }
}

class _cameraState extends State<camera> {
  File? _image;
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

    return File(imagepath).copy(image.path);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getCamera(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        getImage(ImageSource.camera);
      },
    );
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
