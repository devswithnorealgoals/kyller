import 'package:flutter/material.dart';

class Rankings extends StatelessWidget {
  final dynamic players;

  const Rankings(this.players);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.0),
        child: Column(
      children: <Widget>[
        Text('CLASSEMENT', style: TextStyle(fontSize: 36.0, fontFamily: 'gunplay'),),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: players.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 0.0, 16.0, 0.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Text(
                            players[index]['name'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'gunplay',
                                fontSize: 20.0,
                                decoration: players[index]['killed'] == true
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: Text(players[index]['kills'].toString(),
                                style: TextStyle(
                                  fontFamily: 'gunplay',
                                  fontSize: 20.0,
                                )))
                      ]));
            })
      ],
    ));
  }
}
