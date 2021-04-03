import 'db_helpers.dart';

randomMissions(int i) async {
  var allMissions = await getMissions();
  allMissions.documents.shuffle();
  var randomMissions = allMissions.documents.take(i).toList();
  return randomMissions
      .map((mission) => mission.data["mission"].toString())
      .toList();
}
