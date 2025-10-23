const {onCall} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const {initializeApp, getApps} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");

// Initialize Firebase Admin if not already initialized
if (!getApps().length) {
  initializeApp();
}

const db = getFirestore();

exports.createUserIfNotExists = onCall(async (request) => {
  const auth = request.auth;
  const data = request.data;

  if (!auth) {
    throw new Error("User must be authenticated to call this function.");
  }

  const uid = auth.uid;
  const {username, email} = data;

  if (!username || !email) {
    throw new Error("Username and email are required.");
  }

  try {
    const userDoc = await db.collection("users").doc(uid).get();

    if (!userDoc.exists) {
      await db.collection("users").doc(uid).set({
        username,
        email,
        favourites: [],
        rightSwipes: [],
        leftSwipes: [],
        reservationsHistory: [],
        currentReservations: [],
      });
      logger.info(`User document created for UID: ${uid}`);
      return {message: "User document created"};
    } else {
      logger.info(`User document already exists for UID: ${uid}`);
      return {message: "User document already exists"};
    }
  } catch (error) {
    logger.error("Error creating user document:", error);
    throw new Error(error.message);
  }
});
