import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> getGames() {
  return FirebaseFirestore.instance.collection('games').get();
}

DocumentReference getGameInfos(String docId) {
  return FirebaseFirestore.instance.collection('games').doc(docId);
}

Stream<DocumentSnapshot> getGameSnapshot(String docId) {
  return FirebaseFirestore.instance.collection('games').doc(docId).snapshots();
}

Future<QuerySnapshot> getGameInfosByName(String gameName) async {
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

Future<QuerySnapshot> getMissions() {
  return FirebaseFirestore.instance.collection('missions').get();
}
