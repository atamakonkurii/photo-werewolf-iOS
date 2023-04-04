import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

const db = admin.firestore();

/* eslint-disable max-len */
export const standardGameExchangePhotoUrl = functions.region("asia-northeast1").https.onCall(async (data, _context) => {
  type GameUser = {
    id: string;
    role: string;
    photoUrl: string;
    exchangePhotoUrl: string | null;
  }[];

  /**
 * Shuffle the elements of an array using the Fisher-Yates algorithm and return a new array.
 * @template T The type of elements in the array.
 * @param {T[]} array - The input array to be shuffled.
 * @return {T[]} A new array with shuffled elements.
 */
  function shuffleArray<T>(array: T[]): T[] {
    const copy = [...array];
    for (let i = copy.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [copy[i], copy[j]] = [copy[j], copy[i]];
    }
    return copy;
  }

  // もしroleがwerewolfであれば、他のwerewolfのphotoUrlをexchangePhotoUrlに保存する
  // roleがvillagerであれば自身のphotoUrlをexchangePhotoUrlに保存する

  /**
 * Exchange photoUrl between werewolves and return a new array with updated exchangePhotoUrl.
 * @param {GameUser} users - The array of GameUser objects.
 * @return {GameUser} A new array with updated exchangePhotoUrl for werewolves.
 */
  function exchangeWerewolfPhotoUrls(users: GameUser): GameUser {
    const werewolves = users.filter((user) => user.role === "werewolf");
    const shuffledWerewolves = shuffleArray(werewolves);
    const werewolfExchangeMap = new Map<string, string>();

    for (let i = 0; i < werewolves.length; i++) {
      const currentWerewolf = werewolves[i];
      const nextWerewolf = shuffledWerewolves[(i + 1) % shuffledWerewolves.length];
      werewolfExchangeMap.set(currentWerewolf.id, nextWerewolf.photoUrl);
    }

    return users.map((user) => {
      if (user.role === "werewolf") {
        user.exchangePhotoUrl = werewolfExchangeMap.get(user.id) || null;
      } else {
        user.exchangePhotoUrl = user.photoUrl;
      }
      return user;
    });
  }

  const gameRoomId = data.gameRoomId;

  if (!gameRoomId) {
    throw new functions.https.HttpsError("invalid-argument", "gameRoomId is required.");
  }

  const gameUsersSnapshot = await db.collection(`rooms/${gameRoomId}/gameUsers`).get();

  const gameUsers: GameUser = gameUsersSnapshot.docs.map((doc) => ({id: doc.id, role: doc.data().role, photoUrl: doc.data().photoUrl, exchangePhotoUrl: null, ...doc.data()}));

  const exchangedPhotoUrlUsers = exchangeWerewolfPhotoUrls(gameUsers);

  // Update Firestore
  const batch = db.batch();

  exchangedPhotoUrlUsers.forEach((user) => {
    const userRef = db.doc(`rooms/${gameRoomId}/gameUsers/${user.id}`);
    batch.update(userRef, {exchangePhotoUrl: user.exchangePhotoUrl});
  });

  await batch.commit();

  return {message: "Roles assigned successfully"};
});
/* eslint-enable max-len */
