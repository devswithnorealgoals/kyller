import 'package:flutter/material.dart';
import '../services/functions_helpers.dart';
import '../services/utils.dart';
import '../services/preferences.dart';
import './join_game.dart';
import './missions_choice.dart';

class NameGame extends StatefulWidget {
  final List<String> players;

  NameGame(this.players);
  @override
  _NameGameState createState() => _NameGameState();
}

class _NameGameState extends State<NameGame> {
  final gameNameController = TextEditingController();
  bool _includeCounterKill = false;
  bool _includeCustomMissions = false;

  void _counterKillChanged(bool value) =>
      setState(() => _includeCounterKill = value);
  void _customMissionsChanged(bool value) =>
      setState(() => _includeCustomMissions = value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PARAMÈTRES",
              style: TextStyle(fontFamily: 'gunplay', fontSize: 20.0)),
        ),
        body: Builder(
          builder: (builderContext) => Center(
                  child: Column(children: [
                Padding(
                  child: Text("Comment s'appelle votre partie ?",
                      style: TextStyle(fontFamily: 'courier', fontSize: 14.0)),
                  padding: EdgeInsets.all(40),
                ),
                Padding(
                  child: TextField(
                    style: TextStyle(fontFamily: 'courier'),
                    controller: gameNameController,
                  ),
                  padding: EdgeInsets.all(40),
                ),
                new CheckboxListTile(
                  value: _includeCounterKill,
                  onChanged: _counterKillChanged,
                  title: new Text(
                    'CONTRE-KILL',
                    style: TextStyle(fontFamily: 'gunplay', fontSize: 24.0),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: new Text(
                      'Donne la possibilité à une cible de tuer son assassin',
                      style: TextStyle(fontFamily: 'courier', fontSize: 12.0)),
                  activeColor: Colors.amber,
                ),
                new CheckboxListTile(
                  value: _includeCustomMissions,
                  onChanged: _customMissionsChanged,
                  title: new Text(
                    'CUSTOM MISSIONS',
                    style: TextStyle(fontFamily: 'gunplay', fontSize: 24.0),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  subtitle: new Text(
                      'Donne la possibilité d\'ajouter ses propres missions',
                      style: TextStyle(fontFamily: 'courier', fontSize: 12.0)),
                  activeColor: Colors.amber,
                ),
                Padding(
                  child: FlatButton(
                      color: Colors.amber,
                      child: Text(
                        'START !',
                        style: TextStyle(fontFamily: 'gunplay', fontSize: 24.0),
                      ),
                      onPressed: () async {
                        if (_includeCustomMissions == false) {
                          var missions = randomMissions(widget.players.length);
                          var game = await createGame(gameNameController.text,
                              widget.players, missions, _includeCounterKill);
                          if (game["result"] != null) {
                            navigateToGame(game["result"], context);
                          } else {
                            final snackBar = SnackBar(
                              content: Text('Ce nom est déjà pris !'),
                            );
                            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                            Scaffold.of(builderContext).showSnackBar(snackBar);
                          }
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MissionsChoice(widget.players, _includeCounterKill)),
                          );
                        }
                      }),
                  padding: EdgeInsets.all(40),
                ),
              ])),
        ));
  }
}

navigateToGame(String game, BuildContext context) async {
  var set = await setGameId(game);
  if (set == true) {
    print("go to ${game}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinGame()),
    );
  } else {
    print('error saving game id');
  }
}
