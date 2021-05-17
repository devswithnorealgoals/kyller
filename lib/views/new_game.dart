import 'package:flutter/material.dart';
import 'package:kyller/main.dart';
import '../prompt_dialog.dart';
import './name_game.dart';
import 'dart:math';

class NewGame extends StatefulWidget {
  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  List<PlayerListItem> _players = [];
  ScrollController _scrollController = new ScrollController();

  var rng = new Random();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LES JOUEURS",
              style: TextStyle(fontSize: 20.0, fontFamily: 'gunplay')),
        ),
        body: Builder(
            builder: (builderContext) => Center(
                    child: Column(children: [
                  Padding(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            getButton('AJOUTER UN JOUEUR', () {
                              _addPlayer(context);
                            }),
                            _players.length < 2
                                ? getButton('SUIVANT', () {
                                    if (_players.length < 2) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Il faut au moins 2 joueurs !'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(builderContext)
                                          .showSnackBar(snackBar);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NameGame(
                                                _players
                                                    .map((p) => p.name)
                                                    .toList())),
                                      );
                                    }
                                  }, 'disabled')
                                : getButton('SUIVANT', () {
                                    if (_players.length < 2) {
                                      final snackBar = SnackBar(
                                        content: Text(
                                            'Il faut au moins 2 joueurs !'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(builderContext)
                                          .showSnackBar(snackBar);
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NameGame(
                                                _players
                                                    .map((p) => p.name)
                                                    .toList())),
                                      );
                                    }
                                  }, 'primary')
                          ]),
                      padding: EdgeInsets.only(top: 50.0)),
                  Expanded(
                      child: Padding(
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                        height: 0.0,
                      ),
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: _players.length,
                      itemBuilder: (context, index) => this._buildRow(index),
                    ),
                    padding: EdgeInsets.only(top: 36.0),
                  ))
                ]))));
  }

  void _addPlayer(BuildContext context) {
    asyncInputDialog(context)
        .then((value) => checkIfExistsAndAddPlayer(value, context))
        .catchError((error) => {print(error)});
  }

  void checkIfExistsAndAddPlayer(name, context) {
    if (_players.where((player) => player.key == new Key(name)).length > 0) {
      _addPlayer(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Le joueur existe déjà.'),
      ));
    } else if (name == "" || name == null) {
    } else {
      setState(() {
        var newPlayer = PlayerListItem(new Key(name), hasDismissed, name);
        _players.insert(0, newPlayer);
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
        onDismissed: (direction) => this.isDismissed(this.key),
        key: this.key,
        child: Center(
            child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 6,
                child: Text(
                  this.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'courier',
                    fontSize: 20.0,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: 'Supprimer',
                  onPressed: () {
                    this.isDismissed(this.key);
                  },
                ),
              )
            ],
          ),
        )));
  }
}
