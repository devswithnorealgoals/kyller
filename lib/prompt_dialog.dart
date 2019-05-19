import 'package:flutter/material.dart';

Future<String> asyncInputDialog(BuildContext context) async {
  String teamName = '';
  return showDialog<String>(
    context: context,
    barrierDismissible: true, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Prénom du participant'),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Nom', hintText: 'Pedro'),
                onChanged: (value) {
                  teamName = value;
                },
              )
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop(teamName);
            },
          ),
          FlatButton(
            child: Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          )
        ],
      );
    },
  );
}

