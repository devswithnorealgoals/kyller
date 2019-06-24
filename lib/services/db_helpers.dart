import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> getGames(){
  return Firestore.instance.collection('games').getDocuments();
}

DocumentReference getGameInfos(String docId){
  return Firestore.instance.collection('games').document(docId);
}

Stream<DocumentSnapshot> getGameSnapshot(String docId) {
  return Firestore.instance.collection('games').document(docId).snapshots();
}

Future<QuerySnapshot> getGameInfosByName(String gameName) async {
  return Firestore.instance.collection('games').where('name', isEqualTo: gameName).getDocuments();
}

Future<DocumentReference> addGame(List players, String name){
  return Firestore.instance.collection('games').add({
    "name": name,
    "players": players
  });
}

Future<QuerySnapshot> getMissions(){
  return Firestore.instance.collection('missions').getDocuments();
}