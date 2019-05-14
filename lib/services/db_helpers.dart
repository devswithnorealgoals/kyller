import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> getGames(){
  return Firestore.instance.collection('games').getDocuments();
}

DocumentReference getGameInfos(String docId){
  return Firestore.instance.collection('games').document(docId);
}

Future<DocumentReference> addGame(List players, String name){
  return Firestore.instance.collection('games').add({
    "name": name,
    "players": players
  });
}