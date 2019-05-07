import 'package:flutter/material.dart';
import '../services/functions_helpers.dart';

class NameGame extends StatefulWidget {
  final List<String> players;
  
  NameGame(this.players);
  @override

  _NameGameState createState() => _NameGameState();
}

class _NameGameState extends State<NameGame> {
  final gameNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nom de la partie ?"),
      ),
      body: Center(
        child: Column(
          children: [
              Padding(
                child: Text("Comment s'appelle votre partie"), 
                padding: EdgeInsets.all(40),),
              Padding(
                child: TextField(
                  controller: gameNameController,
                ), 
                padding: EdgeInsets.all(40),),
              Padding(
                child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Start !'),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                     createGame(gameNameController.text);
                    }
                  ),
                padding: EdgeInsets.all(40),
                ),
            ]
        )
      ),
    );
  }
}