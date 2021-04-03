import 'package:cloud_functions/cloud_functions.dart';

testName(String name) async {
  try {
    final dynamic resp = await FirebaseFunctions.instance
        .httpsCallable(
      'testName',
    )
        .call({'name': name});
    return resp;
  } on Error catch (e) {
    print('caught firebase functions exception');
    print(e);
  }
}

createGame(String name, List<String> players, List<String> missions,
    bool includeCounterKill) async {
  try {
    final dynamic resp =
        await FirebaseFunctions.instance.httpsCallable('createGame').call({
      'message': 'hello world!',
      'name': name,
      'players': players,
      'missions': missions,
      'includeCounterKill': includeCounterKill
    });
    return resp;
  } on Error catch (e) {
    print(e);
    print('caught firebase functions exception');
  }
}

killed(String gameId, String playerName, String status) async {
  try {
    print(gameId);
    print(playerName);
    print(status);
    final dynamic resp = await FirebaseFunctions.instance
        .httpsCallable(
      'killed',
    )
        .call({
      'gameId': gameId,
      'playerName': playerName,
      'status': status,
    });
    print("responsed");
    print(resp);
    return resp;
  } on Error catch (e) {
    print(e);
    print('caught firebase functions exception');
  }
}
