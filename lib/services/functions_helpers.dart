import 'package:cloud_functions/cloud_functions.dart';

testName(String name) async {
  try {
    final dynamic resp = await CloudFunctions.instance.call(
      functionName: 'testName',
      parameters: <String, dynamic>{
        'name': name,
      },
    );
    return resp;
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.details);
  } catch (e) {
    print('caught generic exception');
    print(e);
  }
}

createGame(String name, List<String> players, List<String> missions, bool includeCounterKill) async {
  try {
    final dynamic resp = await CloudFunctions.instance.call(
      functionName: 'createGame',
      parameters: <String, dynamic>{
        'message': 'hello world!',
        'name': name,
        'players': players,
        'missions': missions,
        'includeCounterKill': includeCounterKill
      },
    );
    return resp;
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.code);
    print(e.message);
    print(e.details);
  } catch (e) {
    print('caught generic exception');
    print(e);
  }
}


killed(String gameId, String playerName, String status) async {
  try {
    print(gameId);
    print(playerName);
    print(status);
    final dynamic resp = await CloudFunctions.instance.call(
      functionName: 'killed',
      parameters: <String, dynamic>{
        'gameId': gameId,
        'playerName': playerName,
        'status': status,
      },
    );
    print("responsed");
    print(resp);
    return resp;
  } on CloudFunctionsException catch (e) {
    print('caught firebase functions exception');
    print(e.code);
    print(e.message);
    print(e.details);
  } catch (e) {
    print('caught generic exception');
    print(e);
  }
}