import 'package:flutter/material.dart';
import '../prompt_dialog.dart';
import './missions_choice.dart';
import './name_game.dart';
import 'dart:math';


class NewGame extends StatefulWidget {
  @override

  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  
  List<PlayerListItem> _players = [];

  void _addPlayer(BuildContext context) {
    asyncInputDialog(context).then((value) => 
      checkIfExistsAndAddPlayer(value, context)
    ).catchError((error) => {
      print(error)
    });
  }

  void checkIfExistsAndAddPlayer(name, context) {
    if (_players.where((player) => player.key == new Key(name)).length > 0) {
      _addPlayer(context);
    } else if (name == "" || name == null) {

    } else {
      setState(() {
        var newPlayer = PlayerListItem(new Key(name), hasDismissed, name);
        _players.add(newPlayer);
      });
      print(_players);
    }
  }
  
  hasDismissed(Key key) {
    setState(() {
      _players.removeWhere((player) => player.key == key);
    });
    print(_players);
  }
  var rng = new Random();
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Les joueurs"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
              FlatButton(
              textColor: Colors.blue,
              child: Text('Ajouter un joueur'),
              onPressed: () {
                _addPlayer(context);
            }),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Les Missions'),
              shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NameGame(_players.map((p) => p.name).toList())),
              );
            })
            ]),
            Expanded(child: 
             ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _players.length,
              itemBuilder: (context, index) => this._buildRow(index)),
            )
            ]
        )
      ),
    );
  }
  _buildRow(int index) {
    return _players[index];
  }
}

class PlayerListItem extends StatelessWidget {
  final Key key;
  final Function(Key) isDismissed;
  final String name;
  PlayerListItem(this.key, this.isDismissed, this.name);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) => { this.isDismissed(this.key) },
      key: this.key,
      child: Center(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            this.name,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 20,
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Supprimer',
            onPressed: () {
              this.isDismissed(this.key);
            },
          ),
        ],
      ),
      )
    );
  }
}
