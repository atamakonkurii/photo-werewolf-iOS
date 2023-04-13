import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();

/* eslint-disable max-len */
export const standardGameCalculateResult = functions.region("asia-northeast1").https.onCall(async (data, _context) => {
  type User = {
    userId: string
    name: string
    role: string
  }

  type GameUser = {
    id: string;
    userId: string;
    role: string;
    photoUrl: string;
    exchangePhotoUrl: string;
    voteToUser: User;
    result: string | null;
  }[];

  /**
 * Calculate the results (win or lose) for each GameUser based on the given conditions.
 *
 * For werewolves:
 * - Win if the GameUser's userId is not found in any other user's voteToUser.userId.
 * - Lose if the GameUser's userId is found in any other user's voteToUser.userId.
 *
 * For villagers:
 * - Win if the voteToUser's role is 'werewolf'.
 * - Lose if the voteToUser's role is not 'werewolf'.
 *
 * @param {GameUser} gameUsers - An array of GameUser objects.
 * @return {GameUser} An updated array of GameUser objects with the calculated results.
 */
  function calculateGameResults(gameUsers: GameUser): GameUser {
    return gameUsers.map((gameUser) => {
      let result: string | null = null;

      if (gameUser.role === "werewolf") {
        const isVoted = gameUsers.some(
          (otherUser) => otherUser.voteToUser.userId === gameUser.userId
        );
        result = isVoted ? "lose" : "win";
      } else if (gameUser.role === "villager") {
        result = gameUser.voteToUser.role === "werewolf" ? "win" : "lose";
      }

      return {
        ...gameUser,
        result,
      };
    });
  }

  const gameRoomId = data.gameRoomId;

  if (!gameRoomId) {
    throw new functions.https.HttpsError("invalid-argument", "gameRoomId is required.");
  }

  const gameUsersSnapshot = await db.collection(`rooms/${gameRoomId}/gameUsers`).get();

  const gameUsers: GameUser = gameUsersSnapshot.docs.map((doc) => ({id: doc.id, userId: doc.data().userId, role: doc.data().role, photoUrl: doc.data().photoUrl, exchangePhotoUrl: doc.data().exchangePhotoUrl, voteToUser: {userId: doc.data().voteToUser.userId, name: doc.data().voteToUser.name, role: doc.data().voteToUser.role}, result: null, ...doc.data()}));

  console.log("gameUsers", gameUsers);

  if (gameUsers.length < 3) {
    throw new functions.https.HttpsError("failed-precondition", "At least 3 players are required.");
  }

  const updatedGameUsers = calculateGameResults(gameUsers);

  console.log("updatedGameUsers", updatedGameUsers);

  // Update Firestore
  const batch = db.batch();

  updatedGameUsers.forEach((user) => {
    const userRef = db.doc(`rooms/${gameRoomId}/gameUsers/${user.id}`);
    batch.update(userRef, {result: user.result});
  });

  await batch.commit();

  return {message: "Roles assigned successfully"};
});
/* eslint-enable max-len */
