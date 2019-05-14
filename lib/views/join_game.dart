import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/db_helpers.dart';


class JoinGame extends StatefulWidget {
  JoinGame();
  @override

  _JoinGameState createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  var _gameId, _players;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      _gameId = instance.getString('currentGameId') ?? null;
      if (_gameId != null) {
        getGameInfos(_gameId).get().then((game) {
          print(game.data["players"]);
          _players = game.data["players"].map((player) => player["name"].toString()).toList();
          setState(() {
          });
        });
      }
      
    });
    // Try reading data from the counter key. If it does not exist, return 0.
  }
  
  @override
  Widget build(BuildContext context) {
    if (_gameId == null || _players == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else { 
    return Scaffold(
      appBar: AppBar(
        title: Text("Partie en cours"),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Qui êtes vous ?"),
            Expanded(child: 
             ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _players.length,
              itemBuilder: (context, index) {
               return new Text(_players[index]);
              }
              ),
            ),
            RaisedButton(
              onPressed: () async {
                var inst = await SharedPreferences.getInstance();
                inst.clear();
              },
              child: Text('Reset game!'),
            ),
          ]
        ) 
      ),
    );
    }
  }
}