import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> getGames() {
  return FirebaseFirestore.instance.collection('games').get();
}

DocumentReference<Map<String, dynamic>> getGameInfos(String docId) {
  return FirebaseFirestore.instance.collection('games').doc(docId);
}

Stream<DocumentSnapshot<Map<String, dynamic>>> getGameSnapshot(String docId) {
  return FirebaseFirestore.instance.collection('games').doc(docId).snapshots();
}

Future<QuerySnapshot<Map<String, dynamic>>> getGameInfosByName(
    String gameName) async {
  return FirebaseFirestore.instance
      .collection('games')
      .where('name', isEqualTo: gameName)
      .get();
}

Future<DocumentReference> addGame(List players, String name) {
  return FirebaseFirestore.instance
      .collection('games')
      .add({"name": name, "players": players});
}

Future<QuerySnapshot<Map<String, dynamic>>> getMissions() {
  return FirebaseFirestore.instance.collection('missions').get();
}
