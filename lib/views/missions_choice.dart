import 'package:flutter/material.dart';

class MissionsChoice extends StatefulWidget {
  final List<String> players;
  MissionsChoice(this.players);
  @override

  _MissionsChoiceState createState() => _MissionsChoiceState();
}

class _MissionsChoiceState extends State<MissionsChoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Les missions"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Start !'),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  onPressed: () {
                })
            ]),
            ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20.0),
              children: <Widget>[
                ListTile(
                  title: const Text('The seat for the narrator'),
                ),
                ListTile(
                  title: const Text('The seat for the narrator'),
                ),
                ListTile(
                  title: const Text('The seat for the narrator'),
                  trailing: const Checkbox(value: false)
                ),
                ListTile(
                  title: const Text('The seat for the narrator'),
                  onTap: () => {print(widget.players)},
                ),
              ],
            )
            ]
        )
      ),
    );
  }
}