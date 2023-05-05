
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class button extends StatelessWidget {
  final String text;
  final Color couleur1,couleur2;
  
  
  button({required this.text,required this.couleur1,required this.couleur2});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.22,
      height: MediaQuery.of(context).size.height * 0.03,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w900, fontFamily: "futura.LT",),
              textAlign: TextAlign.center,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: couleur1,
        border: Border.all(width: 0.5,color: couleur2),

      ),
    );
  }
}
