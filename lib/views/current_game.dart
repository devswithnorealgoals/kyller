import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentGame extends StatefulWidget {
  CurrentGame();
  @override

  _CurrentGameState createState() => _CurrentGameState();
}

class _CurrentGameState extends State<CurrentGame> {
  var _currentPlayer, _currentMission, _currentPlayerToKill, _currentKilledState;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) async {
      print(instance.getString('currentGameId'));
      _currentPlayer = instance.getString('currentPlayer') ?? null;
      _currentMission = instance.getString('currentMission') ?? null;
      _currentPlayerToKill = instance.getString('currentPlayerToKill') ?? null;
      _currentKilledState = instance.getBool('currentKilledState') ?? null;
      setState(() {});
    });
    // Try reading data from the counter key. If it does not exist, return 0.
  }
  
  @override
  Widget build(BuildContext context) {
    if (_currentPlayer == null) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Loading..."),
        ),
      );
    } else if (_currentKilledState == true) {
      return Scaffold(body: new Text('Vous avez été tué !'));
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
                onPressed: () {
                  killed('killed');
                }
              ),
              new RaisedButton(
                child: Text('J\'ai été killé'),
                onPressed: () {
                  killed('got_killed');
                }
              ),
              new RaisedButton(
                child: Text('J\'ai contre killé'),
                onPressed: () {
                  killed('counter_killed');
                }
              ),
              new RaisedButton(
                child: Text('J\'ai été contre killé'),
                onPressed: () {
                  killed('got_counter_killed');
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

killed(String status) {
  print(status);
}