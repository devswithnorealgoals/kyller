import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setGameId(String id) async {
 var prefs = await SharedPreferences.getInstance();
 return prefs.setString('currentGameId', id);
}

getGameId() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString('currentGameId');
}

Future<bool> setGameState(dynamic gameState) async {
 var prefs = await SharedPreferences.getInstance();
 bool finished = true;
 await gameState.forEach((key, value) async {
   if(value is String) {finished = finished && (await prefs.setString(key, value));}
   if(value is bool) {finished = finished && (await prefs.setBool(key, value));}
 });
 return finished;
}