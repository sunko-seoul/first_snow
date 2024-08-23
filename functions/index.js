const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./first-snow-1347c-firebase-adminsdk-gr78v-dcf7e2eaff.json"); // 서비스 계정 키 파일 경로

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

exports.sendPushNotification = functions.https.onRequest((req, res) => {
  const {token, message, payload, title} = req.body; // 클라이언트로부터 토큰과 메시지를 받음

  const sendJSON = {
    notification: {
      title: title,
      body: message,
    },
    data: {
      click_action: "FLUTTER_NOTIFICATION_CLICK",
      payload: payload,
    },
  };

  admin.messaging().sendToDevice(token, sendJSON)
    .then((response) => {
      console.log("푸시 알림 전송 성공:", response);
      console.log(response.results[0].error);
      res.status(200).send("푸시 알림 전송 성공");
    })
    .catch((error) => {
      console.error("푸시 알림 전송 실패:", error);
      res.status(500).send("푸시 알림 전송 실패");
    });
});
