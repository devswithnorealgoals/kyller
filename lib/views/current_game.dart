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
      _currentPlayer,
      _currentGameName,
      _currentGameCounterKillStatus;
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((instance) async {
      print(instance.getString('currentGameId'));
      _currentGameId = instance.getString('currentGameId') ?? null;
      _currentPlayerName = instance.getString('currentPlayer') ?? null;
      getGameSnapshot(_currentGameId).listen((doc) {
        if (doc.exists) {
          _currentPlayers = doc.data['players'];
          _currentGameName = doc.data['name'];
          _currentGameCounterKillStatus = doc.data['counter_kill'];
          print(_currentGameCounterKillStatus);
          _currentPlayers.sort((a, b) {
            // print(b['kills'].compareTo(a['kills']) is int); // WHY GOD WHY ???
            if (a['kills'] < b['kills']) {
              return 1;
            }
            if (a['kills'] > b['kills']) {
              return -1;
            }
            if (a['kills'] == b['kills']) {
              return 0;
            }
          });
          _currentPlayer = _currentPlayers
              .where((player) => player['name'] == _currentPlayerName)
              .toList()[0];
          setState(() {});
        }
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
    } else if (_currentPlayer != null &&
        (_currentPlayerName == _currentPlayer["to_kill"])) {
      return PageView(children: <Widget>[
        Scaffold(
            body: Center(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset('assets/images/complete.png'),
                          new Text(
                            'Félicitations, vous êtes notre meilleur espion !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'courier', fontSize: 20.0),
                          ),
                          new FlatButton(
                              child: Text('MENU',
                                  style: TextStyle(
                                      fontFamily: 'gunplay', fontSize: 32.0)),
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/', (_) => false);
                              })
                        ])))),
        Scaffold(body: Rankings(_currentPlayers))
      ]);
    } else if (_currentPlayer != null && _currentPlayer["killed"] == true) {
      return PageView(children: <Widget>[
        Scaffold(
            body: Center(
          child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/images/failed.png'),
                new Text(
                  'Vous avez été tué !',
                  style: TextStyle(fontFamily: 'courier', fontSize: 20.0),
                ),
                new FlatButton(
                    // color: Colors.amber,
                    child: Text('MENU',
                        style:
                            TextStyle(fontFamily: 'gunplay', fontSize: 32.0)),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/', (_) => false);
                    })
              ]),
        )),
        Scaffold(
          body: Rankings(_currentPlayers),
        )
      ]);
    } else {
      return PageView(children: <Widget>[
        Scaffold(
            body: Stack(
          children: <Widget>[
            SingleChildScrollView(
                child: Padding(
              padding: new EdgeInsets.all(16.0),
              child:

                  // child: Column(
                  //     children: [
                  //   // new FlatButton(
                  //   //     color: Colors.amber,
                  //   //     child: Text(
                  //   //       'J\'AI KILLÉ',
                  //   //       style: TextStyle(
                  //   //           fontFamily: 'gunplay', fontSize: 24.0),
                  //   //     ),
                  //   //     onPressed: () async {
                  //   //       await killed(_currentGameId, _currentPlayerName,
                  //   //           'killed');
                  //   //       // await updateGameState(newGameState['result']);
                  //   //     }),
                  //   new FlatButton(
                  //       color: Colors.amber,
                  //       child: Text(
                  //         'J\'AI ÉTÉ KILLÉ',
                  //         style: TextStyle(
                  //             fontFamily: 'gunplay', fontSize: 24.0),
                  //       ),
                  //       onPressed: () async {
                  //         await killed(_currentGameId, _currentPlayerName,
                  //             'got_killed');
                  //       }),
                  //   // new FlatButton(
                  //   //     child: Text('J\'ai contre killé'),
                  //   //     onPressed: () async {
                  //   //       await killed(
                  //   //           _currentGameId, _currentPlayerName, 'counter_killed');
                  //   //     }),
                  //   _currentGameCounterKillStatus == true
                  //       ? new FlatButton(
                  //           color: Colors.amber,
                  //           child: Text(
                  //             'J\'AI ÉTÉ CONTRE KILLÉ',
                  //             style: TextStyle(
                  //                 fontFamily: 'gunplay', fontSize: 24.0),
                  //           ),
                  //           onPressed: () async {
                  //             await killed(_currentGameId,
                  //                 _currentPlayerName, 'got_counter_killed');
                  //           })
                  //       : null,
                  //   new FlatButton(
                  //       child: Text(
                  //         'MENU',
                  //         style: TextStyle(
                  //             fontFamily: 'gunplay', fontSize: 24.0),
                  //       ),
                  //       onPressed: () {
                  //         Navigator.pushNamedAndRemoveUntil(
                  //             context, '/', (_) => false);
                  //       }),
                  // ].where((o) => o != null).toList())

                  Center(
                      child: Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 42.0, 0.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            _currentGameName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 24.0, fontFamily: 'courier'),
                          )),
                      Container(
                        child: Column(children: [
                          Row(children: [
                            Image.asset(
                              'assets/images/target.png',
                              width: 24.0,
                            ),
                            Text(
                              ' CIBLE : ',
                              style: TextStyle(
                                  fontFamily: 'gunplay', fontSize: 24.0),
                            ),
                          ]),
                          Text(
                            _currentPlayer['to_kill'],
                            style: TextStyle(
                                fontFamily: 'courier', fontSize: 24.0),
                          ),
                          Row(children: [
                            Image.asset(
                              'assets/images/strategy.png',
                              width: 24.0,
                            ),
                            Text(
                              ' MISSION : ',
                              style: TextStyle(
                                  fontFamily: 'gunplay', fontSize: 24.0),
                            ),
                          ]),
                          Container(
                            child: Text(
                              _currentPlayer['mission'],
                              style: TextStyle(
                                  fontFamily: 'courier', fontSize: 24.0),
                            ),
                          )
                        ]),
                      ),
                    ]),
              )),
            )),
            Container(
              child: new RotatedBox(
                  quarterTurns: 3,
                  child: new Text(
                    "RANKINGS",
                    style: TextStyle(fontFamily: 'gunplay', fontSize: 18.0),
                  )),
              alignment: Alignment(1, 0),
            ),
            Container(
              child: new FlatButton(
                  color: Colors.amber,
                  child: Text(
                    'J\'AI ÉTÉ KILLÉ',
                    style: TextStyle(fontFamily: 'gunplay', fontSize: 24.0),
                  ),
                  onPressed: () async {
                    await killed(
                        _currentGameId, _currentPlayerName, 'got_killed');
                  }),
              alignment: Alignment(0, 0.65),
            ),
            Container(
              child: _currentGameCounterKillStatus == true
                  ? new FlatButton(
                      color: Colors.amber,
                      child: Text(
                        'J\'AI ÉTÉ CONTRE KILLÉ',
                        style: TextStyle(fontFamily: 'gunplay', fontSize: 24.0),
                      ),
                      onPressed: () async {
                        await killed(_currentGameId, _currentPlayerName,
                            'got_counter_killed');
                      })
                  : null,
              alignment: Alignment(0, 0.8),
            ),
            Container(
              alignment: Alignment(0, 0.95),
              child: new FlatButton(
                  child: Text(
                    'MENU',
                    style: TextStyle(fontFamily: 'gunplay', fontSize: 24.0),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (_) => false);
                  }),
            )
          ],
        )),
        Scaffold(body: Rankings(_currentPlayers))
      ]);
    }
  }
}
