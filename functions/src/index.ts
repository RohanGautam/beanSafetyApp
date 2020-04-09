import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);

const fcm = admin.messaging();

exports.notifyUser = functions.https.onCall(
    (data, context)=>{
        const users = admin.firestore().collection('userData'); //just a reference
        console.log("notifyUser called!")
        users.get().then(function(querySnapshot) {
           querySnapshot.forEach(async function (doc){
            console.log(doc.id, " => ", doc.data());
            const notificationPayload: admin.messaging.MessagingPayload = {
                notification : {
                    title: 'Alert!',
                    body: `Alert type ${data['alertType']}, level ${data['alertLevel']} from ${data['from']}`,
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK'
                }
            };
            const fcmToken = doc.data()['fcmToken'];
            const result = await fcm.sendToDevice(fcmToken, notificationPayload);
            console.log(`Send notification result : ${result}`)
           })
        }).catch(function(error) {
            console.log("Error getting document:", error);
        });
        return {
            'sent': "true"
        };
    }
);


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


