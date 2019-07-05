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
  final _gameNameController = TextEditingController();
  bool _includeCounterKill = false;
  bool _includeCustomMissions = false;
  bool _creating = false;

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
        body: Builder(builder: (builderContext) {
          var center = new Center(
              child: SingleChildScrollView(
                  child: Column(children: [
            Padding(
              child: Text("Comment s'appelle votre partie ?",
                  style: TextStyle(fontFamily: 'courier', fontSize: 20.0)),
              padding: EdgeInsets.all(40),
            ),
            Padding(
              child: TextField(
                style: TextStyle(fontFamily: 'courier'),
                controller: _gameNameController,
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
                    if (_gameNameController.text == '') {
                      return;
                    }
                    if (_includeCustomMissions == false) {
                      var missions =
                          await randomMissions(widget.players.length);
                      setState(() {
                        _creating = true;
                      });
                      var game = await createGame(_gameNameController.text,
                          widget.players, missions, _includeCounterKill);
                      if (game["result"] != null) {
                        setState(() {
                          _creating = false;
                        });
                        navigateToGame(game["result"], context);
                      } else {
                        setState(() {
                          _creating = false;
                        });
                        final snackBar = SnackBar(
                          content: Text('Ce nom est déjà pris !'),
                          duration: Duration(seconds: 1),
                        );
                        // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                        Scaffold.of(builderContext).showSnackBar(snackBar);
                      }
                    } else {
                      setState(() {
                        _creating = true;
                      });
                      var exists = await testName(_gameNameController.text);
                      setState(() {
                        _creating = false;
                      });
                      if (exists["error"] == 'already_exists') {
                        final snackBar = SnackBar(
                          content: Text('Ce nom est déjà pris !'),
                          duration: Duration(seconds: 1),
                        );
                        // Find the Scaffold in the Widget tree and use it to show a SnackBar!
                        Scaffold.of(builderContext).showSnackBar(snackBar);
                      } else if (exists["status"] == 'ok') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MissionsChoice(
                                  widget.players,
                                  _includeCounterKill,
                                  _gameNameController.text)),
                        );
                      } else {
                        print('unknown response no error');
                        print(exists);
                      }
                    }
                  }),
              padding: EdgeInsets.all(40),
            ),
          ])));

          var l = new List<Widget>();
          l.add(center);
          if (_creating == true) {
            var modal = new Stack(
              children: [
                new Opacity(
                  opacity: 0.3,
                  child: const ModalBarrier(
                      dismissible: false, color: Colors.grey),
                ),
                new Center(
                  child: new CircularProgressIndicator(),
                ),
              ],
            );
            l.add(modal);
          }
          var stack = new Stack(children: l);
          return stack;
        }));
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
