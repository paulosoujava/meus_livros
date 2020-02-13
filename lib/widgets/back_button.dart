import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: SizedBox(
            width: 90,
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                  child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
                ),
                Text('Voltar',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white))
              ],
            ),
          ),
        ),
      );
    }
}
