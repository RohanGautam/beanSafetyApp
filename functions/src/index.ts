import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);

exports.notifyUser = functions.https.onCall(
    (data, context)=>{
        const users = admin.firestore().collection('userData'); //just a reference
        console.log("notifyUser called!")
        users.get().then(function(querySnapshot) {
           querySnapshot.forEach(function(doc){
            console.log(doc.id, " => ", doc.data());
           })
        }).catch(function(error) {
            console.log("Error getting document:", error);
        });
        return {
            'users': users
        };
    }
);


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });


