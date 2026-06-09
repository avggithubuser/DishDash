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

  const {username, email} = data;

  if (!username || !email) {
    throw new Error("Username and email are required.");
  }

  try {
    const userDoc = await db.collection("users").doc(email).get();

    if (!userDoc.exists) {
      await db.collection("users").doc(email).set({
        username,
        email,
        saved: [],
        liked: [],
        rejected: [],
        reservationsHistory: [],
        currentReservations: [],
      });
      logger.info(`User document created for email: ${email}`);
      return {message: "User document created"};
    } else {
      logger.info(`User document already exists for email: ${email}`);
      return {message: "User document already exists"};
    }
  } catch (error) {
    logger.error("Error creating user document:", error);
    throw new Error(error.message);
  }
});
