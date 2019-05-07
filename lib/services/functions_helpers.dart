import 'package:cloud_functions/cloud_functions.dart';

createGame(name) async {
  try {
    final dynamic resp = await CloudFunctions.instance.call(
      functionName: 'createGame',
      parameters: <String, dynamic>{
        'message': 'hello world!',
        'name': name
      },
    );
    print("response");
    print(resp);
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


