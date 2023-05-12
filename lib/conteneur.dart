import 'package:flutter/material.dart';

class conteneur extends StatelessWidget {
  final String text;
  conteneur({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Center(
          child: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: "FuturaLT.ttf"),
      )),
    );
  }
}
