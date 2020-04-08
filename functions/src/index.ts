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
                    body: `You are ${doc.id}. Thanks for your contribution!`,
                    clickAction: 'FLUTTER_NOTIFICATION'
                }
            }
            const result = await fcm.sendToDevice(doc.id, notificationPayload);
            console.log(`Send notification result : ${result}`)
           })
        }).catch(function(error) {
            console.log("Error getting document:", error);
        });
        return {
            'users': "not yet"
        };
    }
);


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


