import 'db_helpers.dart';

randomMissions(int i) async {
  var allMissions = await getMissions();
  allMissions.docs.shuffle();
  var randomMissions = allMissions.docs.take(i).toList();
  return randomMissions
      .map((mission) => mission.data()?['mission'].toString())
      .toList();
}
