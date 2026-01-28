const functions = require("firebase-functions");
const admin = require("firebase-admin");
const dialogflow = require("dialogflow");

admin.initializeApp();

// Dialogflow client
const sessionClient = new dialogflow.SessionsClient();

exports.dialogflowChat = functions.https.onRequest(async (req, res) => {
  try {
    if (req.method !== "POST") {
      return res.status(405).json({ reply: "Method not allowed" });
    }

    const { message, uid } = req.body;

    if (!message || !uid) {
      return res.status(400).json({ reply: "Invalid request" });
    }

    const projectId = "smartwed-b8a99";
    const sessionId = uid;
    const sessionPath = sessionClient.sessionPath(projectId, sessionId);

    const request = {
      session: sessionPath,
      queryInput: {
        text: {
          text: message,
          languageCode: "en",
        },
      },
    };

    const responses = await sessionClient.detectIntent(request);
    const result = responses[0].queryResult;

    return res.status(200).json({
      reply: result.fulfillmentText || "I didn’t understand that.",
    });
  } catch (error) {
    console.error("Dialogflow Error:", error);
    return res.status(500).json({
      reply: "AI service error. Try again.",
    });
  }
});




// const functions = require("firebase-functions");
// const fetch = require("node-fetch");
// const { GoogleAuth } = require("google-auth-library");
// const path = require("path");

// exports.dialogflowChat = functions.https.onRequest(async (req, res) => {
//   try {
//     const { message, uid } = req.body;

//     if (!message || !uid) {
//       return res.status(400).json({ reply: "Missing message or user ID" });
//     }

//     // 🔐 Authenticate using service account
//     const auth = new GoogleAuth({
//       keyFile: path.join(__dirname, "dialogflow-key.json"),
//       scopes: ["https://www.googleapis.com/auth/dialogflow"],
//     });

//     const client = await auth.getClient();
//     const accessToken = await client.getAccessToken();

//     // 🎯 Dialogflow REST API
//     const url = `https://dialogflow.googleapis.com/v2/projects/smartwed-b8a99/agent/sessions/${uid}:detectIntent`;

//     const response = await fetch(url, {
//       method: "POST",
//       headers: {
//         "Authorization": `Bearer ${accessToken.token}`,
//         "Content-Type": "application/json",
//       },
//       body: JSON.stringify({
//         queryInput: {
//           text: {
//             text: message,
//             languageCode: "en",
//           },
//         },
//       }),
//     });

//     const data = await response.json();

//     res.json({
//       reply:
//         data.queryResult?.fulfillmentText ||
//         "Sorry, I didn't understand that.",
//     });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ reply: "Dialogflow error" });
//   }
// });
