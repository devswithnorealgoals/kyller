/* eslint-disable promise/always-return */
/* eslint-disable promise/no-nesting */
/* eslint-disable promise/catch-or-return */
const functions = require('firebase-functions');
var admin = require("firebase-admin");
var serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://kyller.firebaseio.com"
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase!");
});

exports.createGame = functions.https.onRequest((req, res) => {
    let name = req.body.data.name
    const store = admin.firestore()
    store.collection('games').where('name', '==', name).get().then((querySnapshot) => {
        if (querySnapshot.docs.length > 0) { 
            res.send({data: { error: 'already_exists', message: 'The game name is already taken' }})
        } else {
            res.send({data: { result: 'created', message: 'The game name is not taken' }})
        }
    }).catch(reason => {
        console.log(reason)
        res.send({reason})
    })

  })
