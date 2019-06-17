import 'package:flutter/material.dart';

class MissionsChoice extends StatefulWidget {
  final List<String> players;
  final bool includeCounterKill;
  MissionsChoice(this.players, this.includeCounterKill);
  @override
  _MissionsChoiceState createState() => _MissionsChoiceState();
}

class _MissionsChoiceState extends State<MissionsChoice> {
  List<String> _missions = [];
  String _missionTyped;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Les missions"),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: [
          new TextField(
            style: TextStyle(fontFamily: 'courier'),
            autofocus: true,
            decoration: new InputDecoration(
                labelText: '', hintText: 'Faire boire un shot de tequila.'),
            onChanged: (value) {
              _missionTyped = value;
            },
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    color: Colors.amber,
                    child: Text('Ajouter'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: () {
                      _missions.insert(0, _missionTyped);
                      _missionTyped = null;
                      setState(() {});
                    })
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
              itemBuilder: (context, index) => Text(
                    _missions[index],
                    style: TextStyle(fontSize: 14.0, fontFamily: 'courier'),
                  ),
            ),
            padding: EdgeInsets.only(top: 26.0),
          ))
        ]),
      )),
    );
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
