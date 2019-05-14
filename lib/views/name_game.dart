import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/functions_helpers.dart';
import '../services/utils.dart';
import './join_game.dart';

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
      body: Builder(
        builder: (contextOfBuilder) => 
      Center(
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
                  onPressed: () async {
                    var missions = randomMissions(widget.players.length);
                    var game = await createGame(gameNameController.text, widget.players, missions);
                    if (game["result"] != null) { navigateToGame(game["result"], context); } else {
                      final snackBar = SnackBar(
                      content: Text('Ce nom est déjà pris !'),
                    );
                    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                    Scaffold.of(contextOfBuilder).showSnackBar(snackBar);
                    }
                  }
                ),
                padding: EdgeInsets.all(40),
              ),
            ]
        )
      ),
      ) 
    );
  }
}

navigateToGame(dynamic game, BuildContext context) async {
  // obtain shared preferences
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('currentGameId', game);
  print("go to ${game}");
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => JoinGame()),
  );
}