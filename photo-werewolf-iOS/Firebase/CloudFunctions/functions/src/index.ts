import * as functions from "firebase-functions";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// https://asia-northeast1-photo-werewolf.cloudfunctions.net/helloWorldTokyo
/* eslint-disable max-len */
export const helloWorldTokyo = functions.region("asia-northeast1").https.onRequest((request, response) => {
  /* eslint-enable max-len */
  functions.logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Tokyo!");
});
