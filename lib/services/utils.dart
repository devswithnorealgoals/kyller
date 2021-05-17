import 'package:cloud_firestore/cloud_firestore.dart';
import 'db_helpers.dart';

Future<List<String>> randomMissions(int i) {
  return getMissions().then((allMissions) {
    allMissions.docs.shuffle();
    var selectedMissions = allMissions.docs.take(i).toList();
    print(selectedMissions);
    List<String> finalMissions = selectedMissions
        .map((mission) => mission.data()['mission'].toString())
        .toList();

    print(finalMissions);
    return finalMissions;
  });
  // try {
  //   var allMissions = await getMissions();
  //   allMissions.docs.shuffle();
  //   List<DocumentSnapshot<Map<String, dynamic>>> randomMissions =
  //       allMissions.docs.take(i).toList();
  //   print(randomMissions
  //       .map((mission) => mission.data()?['mission'].toString())
  //       .toList());
  //   return randomMissions
  //       .map((mission) => mission.data()?['mission'].toString())
  //       .toList();
  // } catch (e) {
  //   print('Erreur random');
  //   print(e);
  //   throw e;
  // }
}
