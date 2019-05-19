import 'package:flutter/material.dart';

Future<bool> asyncAlertialog(String question, BuildContext context) async {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        content: new Text(question),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          )
        ],
      );
    },
  );
}

