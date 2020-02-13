import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error extends StatelessWidget {

  String error;
  String title;
  bool isEmpty;
  Error(this.error, {this.title,  this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            title??"Oh meu Deus por que?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20  ,
              decoration: TextDecoration.none,
            ),
          ),
        ),
        Image.asset(
          isEmpty ? 'assets/empty.png' : 'assets/images/error.png' ,
          width: 120,
          alignment: Alignment.centerLeft,
        ),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            error,
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              decoration: TextDecoration.none,
            ),
          ),
        )
      ],
    );
  }
}