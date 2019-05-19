import 'package:shared_preferences/shared_preferences.dart';

Future<bool> setGameId(String id) async {
 var prefs = await SharedPreferences.getInstance();
 return prefs.setString('currentGameId', id);
}

getGameId() async {
  var prefs = await SharedPreferences.getInstance();
  return prefs.getString('currentGameId');
}