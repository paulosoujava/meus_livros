import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meus_livros/utils/prefs.dart';

Future push(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    return Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
      return page;
    }));
  } else {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }
}

bool pop<T extends Object>(BuildContext context, [T result]) {
  return Navigator.pop(context);
}

opsAlert(BuildContext context, String msg, {String ops = "Ops"}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(ops),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);

              },
            )
          ],
        ),
      );
    },
  );
}
