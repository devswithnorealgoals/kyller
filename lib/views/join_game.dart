import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../alert_dialog.dart';
import '../services/db_helpers.dart';
import '../services/preferences.dart';
import 'current_game.dart';


class JoinGame extends StatefulWidget {
  JoinGame();
  @override

  _JoinGameState createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  var _gameId, _players, _gameName;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      _gameId = instance.getString('currentGameId') ?? null;
      if (_gameId != null) {
        getGameInfos(_gameId).get().then((game) {
          print(game.data["players"]);
          _players = game.data["players"];
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
          title: new Text("Rejoindre une partie"),
        ),
        body: new Column(
          children: [
            new Text('Comment s\'appelle la partie ?'),
            new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Nom', hintText: 'Pedro'),
                onChanged: (value) {
                  _gameName = value;
                },
            ),
            new RaisedButton(
              child: new Text('OK'),
              onPressed: () {
                setGame(_gameName).then((game) async {
                  if (game == false) {
                    print('error trying to set game');
                  } else {
                    print('returning');
                    print(game);
                    _gameId = game['id'];
                    _players = game['players'];
                    setState(() {});
                  }
                });
              }
            )
          ]
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
                return SizedBox(
                  width: double.infinity,
                  // height: double.infinity,
                  child: new RaisedButton(
                    onPressed: () => goToCurrentGame(_players[index], context),
                    child: Text(_players[index]['name']),
                  ),
                );
              }
              ),
            ),
            RaisedButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.clear();
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

goToCurrentGame(player, context) {
  var areYou = 'Vous êtes bien ' + player['name'] + '?';
  asyncAlertialog(areYou, context).then((iAm) {
    if (iAm == true) {
      setPlayer(player).then((ok) {
        if (ok == true) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CurrentGame()),
          );
        }
      });
    }
  });
}

setGame(gameName) async {
  var games = (await getGameInfosByName(gameName)).documents;
  if (games.length == 0) {
    print('Not found');
    return false;
  } else {
    return (await setGameId(games[0].documentID)) == true ? {'id': games[0].documentID, 'players': games[0].data['players']} : false;
  }
}

setPlayer(player) async {
  print(player);
  var prefs = await SharedPreferences.getInstance();
  var playerSet = await prefs.setString('currentPlayer', player['name']);
  var missionSet = await prefs.setString('currentMission', player['mission']);
  var playerToKillSet = await prefs.setString('currentPlayerToKill', player['to_kill']);
  var killed = await prefs.setBool('currentKilledState', player['killed']);
  return playerSet && missionSet && playerToKillSet && killed;
}