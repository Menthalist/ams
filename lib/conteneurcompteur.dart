import 'package:ams_mobile/camera.dart';
import 'package:ams_mobile/providers/dialogProvider.dart';
import 'package:flutter/material.dart';

/*class conteneurProvider<compteur_list> extends ChangeNotifier{
  String compteur,consom;
}*/
class conteneurcompteur extends StatelessWidget {
  final String compteur, consom;
  DialogProvider dialogProvider = DialogProvider();
  VoidCallback onDelete;
  conteneurcompteur(
      {required this.compteur, required this.consom, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
          border:
              Border.all(width: 1.0, color: Color.fromARGB(218, 219, 219, 215)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
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
            ), //BoxShoxSh
          ]),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
              ),
              child: Image(image: AssetImage("assets/img/co.png")),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 7, left: 10),
                child: Text(
                  '$compteur ',
                  style: TextStyle(
                    fontFamily: "FuturaLT.ttf",
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('$consom',
                    style: TextStyle(
                      fontFamily: "FuturaLT.ttf",
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.justify),
              ),
            ],
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 140),
                ),
                InkWell(
                  child: Align(
                    alignment: Alignment.centerRight,
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
                                  'Previsuliser',
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
                                title: Text(
                                  'Supprimer',
                                  style: TextStyle(
                                    fontFamily: "FuturaLT.ttf",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                leading: Icon(
                                  Icons.delete,
                                  color: Colors.black,
                                ),
                                onTap: onDelete,
                              ),
                            ],
                          );
                        });
                  }),
                )
              ]),
        ],
      ),
    );
  }
}
