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
          setState(() {});
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
            title: new Text("REJOINDRE",
                style: TextStyle(fontSize: 20.0, fontFamily: 'gunplay')),
          ),
          body: Builder(
            builder: (builderContext) => new Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [
                  new Text('Comment s\'appelle la partie ?',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20.0, fontFamily: 'courier')),
                  new TextField(
                    style: TextStyle(fontFamily: 'courier'),
                    autofocus: true,
                    decoration: new InputDecoration(
                        labelText: '', hintText: '007 Crew'),
                    onChanged: (value) {
                      _gameName = value;
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new FlatButton(
                          color: Colors.amber,
                          child: new Text(
                            'OK',
                            style: TextStyle(
                                fontFamily: 'gunplay', fontSize: 20.0),
                          ),
                          onPressed: () {
                            setGame(_gameName).then((game) async {
                              print(game);
                              print('game');
                              if (game == false) {
                                final snackBar = SnackBar(
                                  content:
                                      Text('Impossible de trouver la partie !'),
                                );
                                Scaffold.of(builderContext)
                                    .showSnackBar(snackBar);
                                print('error trying to set game');
                              } else {
                                _gameId = game['id'];
                                _players = game['players'];
                                setState(() {});
                              }
                            });
                          }))
                ])),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          // title: Text("Partie en cours"),
          title: Text("QUI ÊTES-VOUS ?",
              style: TextStyle(fontSize: 18.0, fontFamily: 'gunplay')),
        ),
        body: Center(
            child: Padding(
                child: Column(children: [
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.black,
                              height: 0.0,
                            ),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _players.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: new FlatButton(
                                      onPressed: () => goToCurrentGame(
                                          _players[index], context),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          _players[index]['name'],
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontFamily: 'courier'),
                                        ),
                                      )))
                            ],
                          );
                        }),
                  ),
                ]),
                padding: EdgeInsets.all(20.0))),
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
    return (await setGameId(games[0].documentID)) == true
        ? {'id': games[0].documentID, 'players': games[0].data['players']}
        : false;
  }
}

setPlayer(player) async {
  var prefs = await SharedPreferences.getInstance();
  var playerSet = await prefs.setString('currentPlayer', player['name']);
  var missionSet = await prefs.setString('currentMission', player['mission']);
  var playerToKillSet =
      await prefs.setString('currentPlayerToKill', player['to_kill']);
  var killed = await prefs.setBool('currentKilledState', player['killed']);
  return playerSet && missionSet && playerToKillSet && killed;
}
