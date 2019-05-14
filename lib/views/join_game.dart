import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class JoinGame extends StatefulWidget {
  JoinGame();
  @override

  _JoinGameState createState() => _JoinGameState();
}

class _JoinGameState extends State<JoinGame> {
  var gameId;
  void initState() {
    super.initState();
    final prefs = await SharedPreferences.getInstance();
    // Try reading data from the counter key. If it does not exist, return 0.
    gameId = prefs.getString('currentGame') ?? 'cooucouc';
    print('counter');
    print(gameId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(gameId),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}