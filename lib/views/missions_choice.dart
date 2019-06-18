import 'package:flutter/material.dart';
import '../services/functions_helpers.dart';
import '../services/utils.dart';
import '../services/preferences.dart';
import './join_game.dart';

class MissionsChoice extends StatefulWidget {
  final List<String> players;
  final bool includeCounterKill;
  final String gameName;
  MissionsChoice(this.players, this.includeCounterKill, this.gameName);
  @override
  _MissionsChoiceState createState() => _MissionsChoiceState();
}

class _MissionsChoiceState extends State<MissionsChoice> {
  List<MissionListItem> _missions = [];
  String _missionTyped;
  final _textFieldController = new TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "MISSIONS",
            style: TextStyle(fontFamily: 'gunplay', fontSize: 20.0),
          ),
        ),
        body: Builder(
          builder: (builderContext) => Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Stack(
                  children: <Widget>[
                    Column(children: [
                      new TextField(
                        controller: _textFieldController,
                        style: TextStyle(fontFamily: 'courier'),
                        autofocus: true,
                        decoration: new InputDecoration(
                            labelText: '',
                            hintText: 'Faire boire un shot de tequila.'),
                        onChanged: (value) {
                          _missionTyped = value;
                        },
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              child: RaisedButton(
                                  color: Colors.amber,
                                  child: Text(
                                    'Ajouter',
                                    style: TextStyle(
                                        fontSize: 14.0, fontFamily: 'courier'),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(30.0)),
                                  onPressed: () {
                                    checkIfExistsAndAddMission(_missionTyped, builderContext);
                                    setState(() {});
                                  }),
                              padding: EdgeInsets.only(top: 16.0),
                            )
                          ]),
                      Expanded(
                          child: Padding(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                                color: Colors.black,
                                height: 0.0,
                              ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _missions.length,
                          itemBuilder: (context, index) => _missions[index],
                        ),
                        padding: EdgeInsets.only(top: 26.0),
                      ))
                    ]),
                    Container(
                      alignment: Alignment(0, 1),
                      child: FlatButton(
                          color: Colors.amber,
                          child: Text(
                            'DÉMARRER',
                            style: TextStyle(
                                fontFamily: 'gunplay', fontSize: 18.0),
                          ),
                          onPressed: () async {
                            var missions = _missions.map((m) => m.name);
                            var additionalMissions = randomMissions(
                                widget.players.length - _missions.length);
                            missions = new List.from(missions)
                              ..addAll(additionalMissions);
                            print(missions);
                            var game = await createGame(
                                widget.gameName,
                                widget.players,
                                missions,
                                widget.includeCounterKill);
                            if (game["result"] != null) {
                              navigateToGame(game["result"], context);
                              print('démarrer');
                            }
                          }),
                    )
                  ],
                ),
              )),
        ));
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

  void checkIfExistsAndAddMission(name, context) {
    if (_missions.where((mission) => mission.key == new Key(name)).length > 0) {
      final snackBar = SnackBar(
        content: Text('Cette mission existe déjà !'),
        duration: Duration(seconds: 1),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else if (name == "" || name == null) {
    } else if (_missions.length >= widget.players.length) {
      final snackBar = SnackBar(
        content: Text('Pas plus de missions que de joueurs !'),
        duration: Duration(seconds: 1),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        var newmission = MissionListItem(new Key(name), hasDismissed, name);
        _missions.insert(0, newmission);
        _textFieldController.clear();
      });
      print(_missions);
    }
  }

  hasDismissed(Key key) {
    setState(() {
      _missions.removeWhere((mission) => mission.key == key);
    });
    print(_missions);
  }
}

class MissionListItem extends StatelessWidget {
  final Key key;
  final Function(Key) isDismissed;
  final String name;

  MissionListItem(this.key, this.isDismissed, this.name);
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
                  // overflow: TextOverflow.ellipsis,
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
