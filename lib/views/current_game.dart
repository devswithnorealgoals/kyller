import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';


class CurrentGame extends StatefulWidget {
  CurrentGame();
  @override

  _CurrentGameState createState() => _CurrentGameState();
}

class _CurrentGameState extends State<CurrentGame> {
  var _currentPlayer, _currentMission, _currentPlayerToKill;
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) async {
      _currentPlayer = instance.getString('currentPlayer') ?? null;
      _currentMission = instance.getString('currentMission') ?? null;
      _currentPlayerToKill = instance.getString('currentPlayerToKill') ?? null;
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
    } else { 
    return Scaffold(
      body: Padding(
        padding: new EdgeInsets.all(5),
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
                //   Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (BuildContext context) => Home()),
                //   ModalRoute.withName('/'),
                // );
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
