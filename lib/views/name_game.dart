import 'package:flutter/material.dart';
import 'package:kyller/main.dart';
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

  void _counterKillChanged(value) =>
      setState(() => _includeCounterKill = value);
  void _customMissionsChanged(value) =>
      setState(() => _includeCustomMissions = value);

  @override
  Widget build(BuildContext context) {
    var start = (builderContext) {
      return () async {
        print('enculé');
        if (_gameNameController.text == '') {
          ScaffoldMessenger.of(builderContext).showSnackBar(SnackBar(
            content: Text('Donnez un nom à cette partie.'),
            duration: Duration(seconds: 1),
          ));
          return;
        }
        print('va vien');
        print(_includeCustomMissions);
        if (_includeCustomMissions == false) {
          var missions = await randomMissions(widget.players.length);
          setState(() {
            _creating = true;
          });
          try {
            dynamic game = await createGame(_gameNameController.text.trim(),
                widget.players, missions, _includeCounterKill);
            print('SUCCESS !');
            print(game.data);

            if (game.data["result"] != null) {
              setState(() {
                _creating = false;
              });
              navigateToGame(game.data["result"], context);
            } else {
              setState(() {
                _creating = false;
              });
              final snackBar = SnackBar(
                content: Text('Ce nom est déjà pris !'),
                duration: Duration(seconds: 1),
              );
              // Find the Scaffold in the Widget tree and use it to show a SnackBar!
              ScaffoldMessenger.of(builderContext).showSnackBar(snackBar);
            }
          } catch (e) {
            print('Une erreur est survenue');
            print(e);
          }
        } else {
          print('oui');
          setState(() {
            _creating = true;
          });
          var exists = await testName(_gameNameController.text);
          print(exists);
          setState(() {
            _creating = false;
          });
          if (exists["error"] == 'already_exists') {
            final snackBar = SnackBar(
              content: Text('Ce nom est déjà pris !'),
              duration: Duration(seconds: 1),
            );
            // Find the Scaffold in the Widget tree and use it to show a SnackBar!
            ScaffoldMessenger.of(builderContext).showSnackBar(snackBar);
          } else if (exists["status"] == 'ok') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MissionsChoice(widget.players,
                      _includeCounterKill, _gameNameController.text)),
            );
          } else {
            print('unknown response no error');
            print(exists);
          }
        }
      };
    };

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
              child: getButton('START', start(builderContext)),
              padding: EdgeInsets.all(40),
            ),
          ])));

          List<Widget> l = [];
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
    print("go to $game");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinGame()),
    );
  } else {
    print('error saving game id');
  }
}
