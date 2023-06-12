import 'package:flutter/material.dart';
class Mdp extends StatefulWidget {



  @override
  State<Mdp> createState() => _MdpState();
}

class _MdpState extends State<Mdp> {
    TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body:  ListView(
              children: [
          Align(
            alignment: Alignment.center,
            child: Container(
                margin: EdgeInsets.only(top: 97),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.2,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/logo.png"), fit: BoxFit.fill),
                )),
          ),
          SizedBox(
            height: 27,
          ),
          Text(
            "CONNEXION",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Connectez vous et réaliser des etats de lieux",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 40,
          ),
          Container(
              margin: EdgeInsets.only(left: 11),
              child: Text(
                "E-mail addresse",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              )),
          Container(
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.08,
            margin: EdgeInsets.only(left: 11, right: 11, top: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 1.0, color: Color.fromARGB(218, 219, 219, 215)),
            ),
            child: TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "noadjedavid@gmail.com",
                contentPadding: EdgeInsets.only(left: 9, top: 15),
                hintStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                suffixIcon: Icon(
                  Icons.mail,
                  color: Colors.grey.withOpacity(1),
                ),
              ),
            ),
          ),
            SizedBox(
            height: 30,
          ),
          InkWell(
            child: Container(
              margin: EdgeInsets.only(left: 11, right: 11, top: 5),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.08,
              decoration: BoxDecoration(
                color: Color(0xFF333333),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "RECUPERATION",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ),
            onTap: () {
              
            },
          ),
          const SizedBox(
            height: 270,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "AMEXPERT",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
    ] )
      );
  }
}