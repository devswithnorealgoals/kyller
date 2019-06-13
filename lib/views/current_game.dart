import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/functions_helpers.dart';
import '../services/db_helpers.dart';
import './rankings.dart';

class CurrentGame extends StatefulWidget {
  CurrentGame();
  @override
  _CurrentGameState createState() => _CurrentGameState();
}

class _CurrentGameState extends State<CurrentGame> {
  var _currentPlayerName,
      _currentGameId,
      _currentPlayers,
      _currentPlayer;
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((instance) async {
      print(instance.getString('currentGameId'));
      _currentGameId = instance.getString('currentGameId') ?? null;
      _currentPlayerName = instance.getString('currentPlayer') ?? null;
      getGameSnapshot(_currentGameId).listen((doc) {
        _currentPlayers = doc.data['players'];
        _currentPlayer = _currentPlayers
        .where((player) => player['name'] == _currentPlayerName)
        .toList()[0];
        print(_currentPlayer);
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPlayerName == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("No player selected..."),
        ),
      );
    } else if (_currentPlayer != null && (_currentPlayerName == _currentPlayer["to_kill"])) {
      return PageView(children: <Widget>[
       Scaffold(
          body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              new Text('Vous avez gagné la partie !'),
              new RaisedButton(
                  child: Text('Menu principal'),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  })
            ]),
      )),
      Scaffold(
          body: Rankings(_currentPlayers))
      ]);
    } else if (_currentPlayer != null &&  _currentPlayer["killed"] == true) {
      return PageView(children: <Widget>[
      Scaffold(
          body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              new Text('Vous avez été tué !'),
              new RaisedButton(
                  child: Text('Menu principal'),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  })
            ]),
      )),
      Scaffold(
          body: Center(
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              new Text('Classement actuel'),
            ]),
      ))
      ]);
    } else {
      return PageView(children: <Widget>[
       Scaffold(
          body: Padding(
        padding: new EdgeInsets.all(2.0),
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              Text(_currentPlayerName),
              Text(_currentPlayer['mission']),
              Text('sur ' + _currentPlayer['to_kill']),
              new RaisedButton(
                  child: Text('Menu principal'),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  }),
              new RaisedButton(
                  child: Text('J\'ai killé'),
                  onPressed: () async {
                    await killed(_currentGameId, _currentPlayerName, 'killed');
                    // await updateGameState(newGameState['result']);
                  }),
              new RaisedButton(
                  child: Text('J\'ai été killé'),
                  onPressed: () async {
                    await killed(_currentGameId, _currentPlayerName, 'got_killed');
                  }),
              new RaisedButton(
                  child: Text('J\'ai contre killé'),
                  onPressed: () async {
                    await killed(
                        _currentGameId, _currentPlayerName, 'counter_killed');
                  }),
              new RaisedButton(
                  child: Text('J\'ai été contre killé'),
                  onPressed: () async {
                    await killed(
                        _currentGameId, _currentPlayerName, 'got_counter_killed');
                  })
            ])),
      )),
      Scaffold(
          body: Center(
        child: Rankings(_currentPlayers)
      ))
      ]);
    }
  }
}
