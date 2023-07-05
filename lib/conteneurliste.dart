import 'package:flutter/material.dart';

class conteneurliste extends StatelessWidget {
  String nbrecle, piece;
  VoidCallback onDelete;
  Color couleur = Colors.grey;
  conteneurliste({
    required this.piece,
    required this.nbrecle,
    required this.onDelete,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        width: MediaQuery.of(context).size.width * 0.948,
        height: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
            border: Border.all(
                width: 0.8, color: Color.fromARGB(218, 219, 219, 215)),
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
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                  ),
                  child: Image(image: AssetImage("assets/img/cle.png")),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 10),
                    child: Text(
                      '$nbrecle',
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
                    child: Text('$piece',
                        style: TextStyle(
                          fontFamily: "FuturaLT.ttf",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.justify),
                  ),
                ],
              ),
            ],
          ),
          Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 200),
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
                                  'prévisualiser',
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
                                onTap: () {},
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
                                onTap: onDelete,
                              ),
                            ],
                          );
                        });
                  }),
                )
              ]),
        ]));
  }
}
