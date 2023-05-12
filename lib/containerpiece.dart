import 'package:flutter/material.dart';
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.03,
      color: Color.fromRGBO(174, 184, 234, 0.19),
    );
  }
}