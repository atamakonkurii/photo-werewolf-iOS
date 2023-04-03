import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
/* eslint-disable max-len */
export const standardGameAssignRoles = functions.region("asia-northeast1").https.onCall(async (data, _context) => {
  const gameRoomId = data.gameRoomId;

  if (!gameRoomId) {
    throw new functions.https.HttpsError("invalid-argument", "gameRoomId is required.");
  }

  const gameUsersSnapshot = await db.collection(`rooms/${gameRoomId}/gameUsers`).get();

  type GameUser = {
    id: string;
    role: string | null;
  }[];

  const gameUsers: GameUser = gameUsersSnapshot.docs.map((doc) => ({id: doc.id, role: null, ...doc.data()}));

  if (gameUsers.length < 3) {
    throw new functions.https.HttpsError("failed-precondition", "At least 3 players are required.");
  }

  // Shuffle gameUsers array
  for (let i = gameUsers.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [gameUsers[i], gameUsers[j]] = [gameUsers[j], gameUsers[i]];
  }

  // Assign roles
  const werewolfCount = 2;
  for (let i = 0; i < gameUsers.length; i++) {
    gameUsers[i].role = i < werewolfCount ? "werewolf" : "villager";
  }

  // Update Firestore
  const batch = db.batch();

  gameUsers.forEach((user) => {
    const userRef = db.doc(`rooms/${gameRoomId}/gameUsers/${user.id}`);
    batch.update(userRef, {role: user.role});
  });

  await batch.commit();

  return {message: "Roles assigned successfully"};
});
/* eslint-enable max-len */

/* eslint-disable max-len */
export const standardGameExchangePhotoUrl = functions.region("asia-northeast1").https.onCall(async (data, _context) => {
  const gameRoomId = data.gameRoomId;

  if (!gameRoomId) {
    throw new functions.https.HttpsError("invalid-argument", "gameRoomId is required.");
  }

  const gameUsersSnapshot = await db.collection(`rooms/${gameRoomId}/gameUsers`).get();

  type GameUser = {
    id: string;
    role: string;
    photoUrl: string;
    exchangePhotoUrl: string | null;
  }[];

  const gameUsers: GameUser = gameUsersSnapshot.docs.map((doc) => ({id: doc.id, role:doc.data().role, photoUrl: doc.data().photoUrl, exchangePhotoUrl: null, ...doc.data()}));

  // もしroleがwerewolfであれば、他のwerewolfのphotoUrlをexchangePhotoUrlに保存する
  // roleがvillagerであれば自信のphotoUrlをexchangePhotoUrlに保存する
gameUsers.forEach((user) => {
    if (user.role === "werewolf") {
      const werewolfPhotoUrls = gameUsers.filter((user) => user.role === "werewolf").map((user) => user.photoUrl);
      // 自分のphotoUrlを除外する
      user.exchangePhotoUrl = werewolfPhotoUrls.filter((photoUrl) => photoUrl !== user.photoUrl)[0];
    } else {
      user.exchangePhotoUrl = user.photoUrl;
    }
  });

  // Update Firestore
  const batch = db.batch();

  gameUsers.forEach((user) => {
    const userRef = db.doc(`rooms/${gameRoomId}/gameUsers/${user.id}`);
    batch.update(userRef, {exchangePhotoUrl: user.exchangePhotoUrl});
  });

  await batch.commit();

  return {message: "Roles assigned successfully"};
});
/* eslint-enable max-len */