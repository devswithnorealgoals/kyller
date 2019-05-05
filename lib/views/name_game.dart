import 'package:flutter/material.dart';

class NameGame extends StatefulWidget {
  final List<String> players;
  NameGame(this.players);
  @override

  _NameGameState createState() => _NameGameState();
}

class _NameGameState extends State<NameGame> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Les missions"),
      ),
      body: Center(
        child: Column(
          children: [
              Padding(
                child: Text("Comment s'appelle votre partie"), 
                padding: EdgeInsets.all(40),),
              Padding(
                child: TextField(), 
                padding: EdgeInsets.all(40),),
              Padding(
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Start !'),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                    print("pressed");}
                  ),
                padding: EdgeInsets.all(40),
                ),
            ]
        )
      ),
    );
  }
}