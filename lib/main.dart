import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './views/new_game.dart';
import './views/join_game.dart';
import './views/current_game.dart';
import './services/preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math' as math;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class Mission {
  Mission(this.context, this.difficulty, this.mission, this.missionType,
      this.origin);
  final String context;
  final String difficulty;
  final String mission;
  final String missionType;
  final String origin;
}

class Player {
  Player(this.killed, this.kills, this.mission, this.name, this.toKill);
  final bool killed;
  final int kills;
  final String mission;
  final String name;
  final String toKill;
}

class Game {
  Game(this.counterKill, this.name, this.players);
  final bool counterKill;
  final String name;
  final List<Player> players;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kyller',
      theme: ThemeData(primarySwatch: Colors.grey, primaryColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

Transform getButton(String text, void Function() onPressed,
    [String style = 'primary']) {
  Color color = Colors.black;
  Color bgColor = Colors.white;
  switch (style) {
    case 'primary':
      color = Colors.black;
      bgColor = Colors.amber;
      break;
    case 'disabled':
      color = Colors.grey;
      bgColor = Colors.white;
      break;
    case 'secondary':
      color = Colors.black;
      bgColor = Colors.white;
      break;
    default:
      color = Colors.black;
      bgColor = Colors.white;
  }
  return Transform.rotate(
      angle: -10 * math.pi / 180,
      child: new TextButton(
          style: TextButton.styleFrom(
            backgroundColor: bgColor,
            padding: EdgeInsets.only(
                right: 30.0, left: 30.0, top: 10.0, bottom: 10.0),
          ),
          child: new Text(
            text,
            style:
                TextStyle(fontFamily: 'gunplay', color: color, fontSize: 20.0),
          ),
          onPressed: onPressed));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  var animationController;
  @override
  void initState() {
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 15),
    );

    print(animationController);
    animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('First Route'),
      // ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30.0),
            child: Text(
              'THE KILLER',
              style: TextStyle(fontFamily: 'gunplay3d', fontSize: 50.0),
            ),
          ),
          RotationTransition(
            turns: Tween(begin: 0.0, end: 1.0).animate(animationController),
            child: Image.asset(
              'assets/images/target.png',
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
          Container(
            child: Column(children: [
              getButton('NOUVEAU JEU', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewGame()),
                );
              }),
              SizedBox(
                height: 20.0,
              ),
              FutureBuilder(
                  future: getGameId(),
                  builder: (context, snapshot) {
                    var game = snapshot.data;
                    return game == null
                        ? getButton('REJOINDRE', () {
                            joinGame(context);
                          })
                        : getButton('PARTIE EN COURS', () {
                            joinGame(context);
                          });
                  }),
              SizedBox(
                height: 20.0,
              ),
              FutureBuilder(
                  future: getGameId(),
                  builder: (context, snapshot) {
                    return snapshot.data != null
                        ? getButton('QUITTER LA PARTIE', () async {
                            var inst = await SharedPreferences.getInstance();
                            inst.clear();
                            setState(() {});
                          }, 'secondary')
                        : Text('');
                  }),
            ]),
          )
        ],
      )),
    );
  }
}

void joinGame(BuildContext context) async {
  var prefs = await SharedPreferences.getInstance();
  if (prefs.getString('currentPlayer') != null) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CurrentGame()),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinGame()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(''),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
