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


exports.createGame = functions.https.onRequest((req, res) => {
    let name = req.body.data.name
    let players = req.body.data.players
    let missions = req.body.data.missions
    let counterKill = req.body.data.includeCounterKill
    const store = admin.firestore()
    store.collection('games').where('name', '==', name).get().then((querySnapshot) => {
        if (querySnapshot.docs.length > 0) { 
            res.send({data: { error: 'already_exists', message: 'The game name is already taken' }})
        } else {
            game = buildGame(players, missions)
            store.collection('games').add({name, players: game, counter_kill: counterKill}).then((docReference) => {
                res.send({data: { result: docReference.id, message: 'Game created' }})
            })
        }
    }).catch(reason => {
        console.log(reason)
        res.send({reason})
    })

})

exports.killed = functions.https.onCall((data, context) => {
    let gameId = data.gameId
    let playerName = data.playerName
    let status = data.status
    const store = admin.firestore()
    return store.collection('games').doc(gameId).get().then((game) => {
        var newGameState
        try {
            newGameState = killed(game.data().players, playerName, status)
        } catch (e) {
            return { error: 'error in the algorithm', message: e }
        }
        return store.collection('games').doc(gameId).update({players: newGameState}).then(() => {
            return { new: newGameState, previous: game.data().players}
        }, (err) => {
            return {error: 'could not update game state', message: err }
        })
    }, (err) => {
        return { error: 'error getting game', message: err }
    })
})

killed = (players, playerName, status) => {
    var player = players.filter((p) => p.name === playerName && p.killed === false)[0] // soi
    var toKill = players.filter((p) => p.name === player.to_kill && p.killed === false)[0] // à tuer
    var killBy = players.filter((p) => p.to_kill === playerName && p.killed === false)[0] // son tueur
    var killByKillBy = players.filter((p) => p.to_kill === killBy.name && p.killed === false)[0] // le tueur de son tueur
    switch(status) {
        case 'killed':
        players.map((p) => {
            if (p.name === toKill.name) { // p = la personne tuée
                p.killed = true
            }
            if (p.name === playerName) { // p = soi même
                p.to_kill = toKill.to_kill
                p.mission = toKill.mission
                p.kills += 1
            }
            return p
        })
        break;
        case 'got_killed':
        players.map((p) => {
            if (p.name === playerName) { // p = la personne tuée (soi-même)
                p.killed = true
            }
            if (p.name === killBy.name) { // p = son tueur
                p.to_kill = player.to_kill
                p.mission = player.mission
                p.kills += 1
            }
            return p
        })
        break;
        case 'counter_killed':
        players.map((p) => {
            if (p.name === playerName) { // soi même
                p.kills += 1
            }
            if (p.name === killBy.name) { // son tueur (tué)
                p.killed = true
            }
            if (p.name === killByKillBy.name) { // le tueur de son tueur
                p.to_kill = killBy.to_kill
            }
            return p
        })
        break;
        case 'got_counter_killed':
        players.map((p) => {
            if (p.name === playerName) { // soi même
                p.killed = true
            }
            if (p.name === toKill.name) { // sa cible
                p.kills += 1
            }
            if (p.name === killBy.name) { // son tueur
                p.to_kill = player.to_kill
            }
            return p
        })
        break;
    }
    return players
}


buildGame = (players, missions) => {
    let currentPlayer = 0
    let currentMission
    let firstPlayer = players[0]
    let result = []
    while(players.length>0) {
        let name = players[currentPlayer]
        players.splice(currentPlayer, 1)
        if (players.length>0) {
            playerToKillIndex = Math.floor(Math.random() * players.length)
            playerToKill = players[playerToKillIndex]
        } else {
            playerToKillIndex = 0
            playerToKill = firstPlayer
        }
        missionIndex = Math.floor(Math.random() * missions.length)
        result.push({
            name,
            to_kill: playerToKill,
            mission: missions[missionIndex],
            killed: false,
            kills: 0
        })
        currentPlayer = playerToKillIndex
        currentMission = missionIndex
        missions.splice(missionIndex, 1)
        }
    return result
}


