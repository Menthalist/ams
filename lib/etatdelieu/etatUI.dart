import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../listescles.dart';

class etatUIdesign extends StatefulWidget {
  String textedl,
      typedl,
      commentaire,
      signature,
      nbrepar,
      nbrepiece,
      nbrecom,
      datej;
  String? etat;

  Color couleurconteneur = Color.fromRGBO(232, 247, 227, 1);
  Color couleurbordure = Color.fromRGBO(57, 182, 14, 1);
  Color couleursigna = Color.fromRGBO(46, 152, 8, 1);
  etatUIdesign(
      {required this.textedl,
      required this.typedl,
      required this.commentaire,
      required this.signature,
      required this.nbrepiece,
      required this.nbrepar,
      required this.datej,
      required this.nbrecom,
      this.etat});

  @override
  State<etatUIdesign> createState() => _etatUIdesignState();
}

class _etatUIdesignState extends State<etatUIdesign> {
  @override
  void initState() {
    var etat_ = widget.etat;
    if (etat_ != null) {
      if (etat_ == "approuve") {
        widget.couleurbordure = Color.fromRGBO(57, 182, 14, 1);
        widget.couleurconteneur = Color.fromRGBO(232, 247, 227, 1);
        widget.couleursigna = Color.fromRGBO(46, 152, 8, 1);
      } else if (etat_ == "report") {
        widget.couleurbordure = Color.fromRGBO(12, 10, 0, 0.059);
        widget.couleurconteneur = Color.fromRGBO(255, 228, 132, 1);
        widget.couleursigna = Color.fromRGBO(208, 41, 41, 1);
      } else if (etat_ == "attente") {
        widget.couleurbordure = Color.fromRGBO(12, 10, 0, 0.059);
        widget.couleurconteneur = Color.fromRGBO(255, 228, 132, 1);
        widget.couleursigna = Color.fromRGBO(208, 41, 41, 1);
      } else {
        widget.couleurbordure = Color.fromRGBO(208, 41, 41, 1);
        widget.couleurconteneur = Color.fromRGBO(252, 235, 235, 1);
        widget.couleursigna = Color.fromRGBO(208, 41, 41, 1);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => listcle()));
      }),
      child: Container(
        margin: EdgeInsets.only(left: 13, top: 20, right: 13),
        padding: EdgeInsets.only(
          top: 5,
          left: 5,
        ),
        height: MediaQuery.of(context).size.height * 0.22,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: widget.couleurconteneur,
            border: Border(
                left: BorderSide(
                    color: widget.couleurbordure,
                    width: 6.0,
                    style: BorderStyle.solid)),
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 0,
                offset: Offset(0, 4),
                color: Color.fromRGBO(0, 0, 0, 0.1),
              )
            ]),
        // borderRadius: BorderRadius.circular(8)),
        child: ListView(
          children: [
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 10, top: 0),
                    child: Icon(
                      Icons.location_on_outlined,
                      size: 26,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 2, left: 10),
                  child: Text(
                    widget.textedl,
                    style: TextStyle(
                        fontFamily: "FuturaLT.ttf",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 15),
                  child: Text(
                    widget.typedl,
                    style: TextStyle(
                        fontFamily: "FuturaLT.ttf",
                        fontSize: 18,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5, left: 135),
                  child: Text(
                    widget.signature,
                    style: TextStyle(
                        fontFamily: "FuturaLT.ttf",
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: widget.couleursigna),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 5, left: 15, right: 25),
              child: Text(
                widget.commentaire,
                style: TextStyle(
                  fontFamily: "FuturaLT.ttf",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Text(
                "${widget.nbrecom} autres commentaires",
                style: TextStyle(
                    fontFamily: 'FuturaLT.ttf',
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    decoration: TextDecoration.underline),
              ),
            ),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "${widget.nbrepar} Participants",
                  style: TextStyle(
                      fontFamily: 'FuturaLT.ttf',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 15),
                child: Text(
                  "${widget.nbrepiece} pièces commentés",
                  style: TextStyle(
                      fontFamily: 'FuturaLT.ttf',
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      decoration: TextDecoration.underline),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 40),
                child: Text(
                  "${widget.datej}",
                  style: TextStyle(
                    fontFamily: 'FuturaLT.ttf',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}
