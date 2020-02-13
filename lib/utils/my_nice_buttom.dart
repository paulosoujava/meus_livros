import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';

class MyNiceBotton extends StatelessWidget {

  var firstColor = Color(0x000), secondColor = Color(0xff3666c);
  Function onPressed;
  String title;


  MyNiceBotton( this.title, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return NiceButton(
      radius: 20,
      padding: const EdgeInsets.all(15),
      text: title,
      icon: Icons.account_box,
      gradientColors: [secondColor, firstColor],
      onPressed: onPressed,
    );
  }
}
