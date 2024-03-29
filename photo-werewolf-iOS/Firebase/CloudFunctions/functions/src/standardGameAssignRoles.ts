import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();

/* eslint-disable max-len */
export const standardGameAssignRoles = functions.region("asia-northeast1").https.onCall(async (data, _context) => {
  type GameUser = {
    id: string;
    role: string | null;
  }[];

  const gameRoomId = data.gameRoomId;

  if (!gameRoomId) {
    throw new functions.https.HttpsError("invalid-argument", "gameRoomId is required.");
  }

  const gameUsersSnapshot = await db.collection(`rooms/${gameRoomId}/gameUsers`).get();

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
