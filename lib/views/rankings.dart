import 'package:flutter/material.dart';

class Rankings extends StatelessWidget {
  final dynamic players;

  const Rankings(this.players);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: players.length,
      itemBuilder: (context, index) => Text(
            players[index]['name'],
            style: TextStyle(
                color:
                    players[index]['killed'] == true ? Colors.red : Colors.green),
          ),
    ));
  }
}
