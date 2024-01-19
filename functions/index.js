/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });


const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.updateBadgeCount = functions.firestore
    .document("users/{userId}")
    .onUpdate((change, context) => {
      const newData = change.after.data();

      const title = newData.title;
      const subtitle = newData.subtitle;
      const body = newData.body;
      const image = newData.image;
      const link = newData.link;

      const newBadgeCount = newData.badgeCount;

      const message = {
        data: {
          badgeCount: String(newBadgeCount),
          link: link,
        },
        token: newData.fcmToken,
        notification: {
          title: title,
          subtitle: subtitle,
          body: body,
          image: image,
          badge: newBadgeCount,
        },
      };

      return admin.messaging().send(message);
    });

