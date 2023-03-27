import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// https://asia-northeast1-photo-werewolf.cloudfunctions.net/helloWorldTokyo
/* eslint-disable max-len */
export const helloWorldTokyo = functions.region("asia-northeast1").https.onRequest((request, response) => {
  /* eslint-enable max-len */
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Tokyo!");
});

// GameRollの割り振りを行う
export const assignGameRoll = functions.region("asia-northeast1").https.onCall(async (data, context) => {
  const db = admin.firestore();
  const gameRef = db.collection("games").doc(data.gameId);
  const gameDoc = await gameRef.get();
  const gameData = gameDoc.data();
  if (gameData === undefined) {
    throw new Error("Game not found");
  }
  const players = gameData.players;
  const playerIds = Object.keys(players);
  const playerNum = playerIds.length;
  const gameRolls = gameData.gameRolls;
  const gameRollIds = Object.keys(gameRolls);
  const gameRollNum = gameRollIds.length;
  if (playerNum !== gameRollNum) {
    throw new Error("PlayerNum and GameRollNum are not equal");
  }
  const gameRollsShuffled = shuffle(gameRollIds);
  const gameRollsAssigned = {};
  for (let i = 0; i < playerNum; i++) {
    gameRollsAssigned[playerIds[i]] = gameRollsShuffled[i];
  }
  await gameRef.update({
    gameRollsAssigned,
  });
  return {
    gameRollsAssigned,
  };
});

