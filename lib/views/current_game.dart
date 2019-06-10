import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/functions_helpers.dart';
import '../services/preferences.dart';
import '../services/db_helpers.dart';

class CurrentGame extends StatefulWidget {
  CurrentGame();
  @override

  _CurrentGameState createState() => _CurrentGameState();
}

class _CurrentGameState extends State<CurrentGame> {
  var _currentPlayer, _currentMission, _currentPlayerToKill, _currentKilledState, _currentGameId;
  void initState() {
    super.initState();
    
    SharedPreferences.getInstance().then((instance) async {
      print(instance.getString('currentGameId'));
      _currentGameId = instance.getString('currentGameId') ?? null;
      _currentPlayer = instance.getString('currentPlayer') ?? null;
      getGameSnapshot(_currentGameId).listen((doc) {
        print(doc.data['players']);
        updateGameState(doc.data['players']);
        setState(() {});
      });
    });
  }

  updateGameState(List newGameState) async {
    var player = newGameState.where((player) => player['name'] == _currentPlayer).toList()[0];
    setState(() {
      _currentMission = player['mission'] ?? null;
      _currentPlayerToKill = player['to_kill'] ?? null;
      _currentKilledState = player['killed'] ?? null;
      });
  }
  
  @override
  Widget build(BuildContext context) {
    if (_currentPlayer == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else if (_currentPlayer == _currentPlayerToKill) {
      return Scaffold(body: 
      Center(child: 
      new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          new Text('Vous avez gagné la partie !'),
          new RaisedButton(
                child: Text('Menu principal'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                }
              )
        ]
      )
      ,)
      );
    }
     else if (_currentKilledState == true) {
      return Scaffold(body: 
      Center(child: 
      new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          new Text('Vous avez été tué !'),
          new RaisedButton(
                child: Text('Menu principal'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                }
              )
        ]
      )
      ,)
      );
    } else { 
    return Scaffold(
      body: Padding(
        padding: new EdgeInsets.all(2.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(_currentPlayer),
              Text(_currentMission),
              Text('sur ' + _currentPlayerToKill),
              new RaisedButton(
                child: Text('Menu principal'),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                }
              ),
              new RaisedButton(
                child: Text('J\'ai killé'),
                onPressed: () async {
                  await killed(_currentGameId, _currentPlayer ,'killed');
                  // await updateGameState(newGameState['result']);
                }
              ),
              new RaisedButton(
                child: Text('J\'ai été killé'),
                onPressed: () async {
                  await killed(_currentGameId, _currentPlayer ,'got_killed');
                }
              ),
              new RaisedButton(
                child: Text('J\'ai contre killé'),
                onPressed: () async {
                  await killed(_currentGameId, _currentPlayer ,'counter_killed');
                }
              ),
              new RaisedButton(
                child: Text('J\'ai été contre killé'),
                onPressed: () async {
                  await killed(_currentGameId, _currentPlayer ,'got_counter_killed');
                }
              )
            ]
          ) 
        ),
      ) 
    );
    }
  }
}