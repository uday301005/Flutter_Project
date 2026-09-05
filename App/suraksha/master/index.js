const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  const token = req.query.token;

  const message = {
    notification: {
      title: "SOS Alert 🚨",
      body: "User needs help!",
    },
    token: token,
  };

  try {
    await admin.messaging().send(message);
    res.send("Notification sent");
  } catch (e) {
    res.send(e);
  }
});