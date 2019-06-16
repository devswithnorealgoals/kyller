import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  const Options();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "OPTIONS",
            style: TextStyle(fontSize: 20.0, fontFamily: 'gunplay'),
          ),
        ),
        body: Container(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: <Widget>[
              ],
            )));
  }
}
