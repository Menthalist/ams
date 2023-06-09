import 'package:ams_mobile/camera.dart';
import 'package:flutter/material.dart';

class conteneurrubrique extends StatelessWidget {
  final String nbrei, nbrem, piece, typepi;
  final Image image;
  Color couleur = Colors.grey;
  conteneurrubrique(
      {required this.nbrei,
      required this.nbrem,
      required this.piece,
      required this.typepi,
      required this.image,
      required this.couleur});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 10, right: 15),
      width: MediaQuery.of(context).size.width * 0.948,
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
          border:
              Border.all(width: 1.3, color: Color.fromARGB(218, 219, 219, 215)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: couleur,
              offset: const Offset(
                1.0,
                1.0,
              ),
              blurRadius: 8.0,
              spreadRadius: 1.0,
            ), //BoxShadow
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.0, 0.0),
              blurRadius: 0.0,
              spreadRadius: 0.0,
            ), //BoxSh
          ]),
      child: Row(children: [
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(
              left: 10,
            ),
            child: image,
          ),
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 15),
                child: Text(
                  '$piece',
                  style: TextStyle(
                    fontFamily: "FuturaLT.ttf",
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15, top: 5),
                child: Text('$typepi',
                    style: TextStyle(
                      fontFamily: "FuturaLT.ttf",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify),
              ),
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(top: 30, left: 15),
                ),
                Image(
                  image: AssetImage("assets/img/pic.png"),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                Text('$nbrei',
                    style: TextStyle(
                      fontFamily: "FuturaLT.ttf",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
                Text('$nbrem',
                    style: TextStyle(
                      fontFamily: "FuturaLT.ttf",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify),
              ]),
            ]),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 170),
              ),
              InkWell(
                child: Align(
                  child: Image(image: AssetImage("assets/img/bu.png")),
                ),
                onTap: (() {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: new Text(
                                'Photos',
                                style: TextStyle(
                                  fontFamily: "FuturaLT.ttf",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              leading: new Icon(
                                Icons.camera,
                                color: Colors.black,
                              ),
                              onTap: () {
                                camera();
                              },
                            ),
                            ListTile(
                              title: new Text(
                                'Modifier',
                                style: TextStyle(
                                  fontFamily: "FuturaLT.ttf",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              leading: new Icon(
                                Icons.edit,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: new Text(
                                'Supprimer',
                                style: TextStyle(
                                  fontFamily: "FuturaLT.ttf",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              leading: new Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      });
                }),
              )
            ]),
      ]),
    );
  }
}
