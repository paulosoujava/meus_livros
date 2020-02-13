import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTitle extends StatelessWidget {
  bool cor;

  MyTitle({this.cor =  true});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 30),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
            text: 'M',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.display1,
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: cor?Colors.black: Colors.white,
            ),
            children: [
              TextSpan(
                text: 'eu',
                style: TextStyle(color: cor?Colors.blue:Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 's ',
                style: TextStyle(color:cor?Colors.black:Colors.white, fontSize: 30),
              ),
              TextSpan(
                text: 'Li',
                style: TextStyle(color: cor?Colors.blue:Colors.black, fontSize: 30),
              ),
              TextSpan(
                text: 'vros',
                style: TextStyle(color:cor?Colors.black:Colors.white, fontSize: 30),
              ),
            ]),
      ),
    );
  }
}
