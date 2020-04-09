import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/userData.dart';
class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  String fcmToken;  
  //collection reference: programatically creates 'userData' collection if it doesn't exist
  final CollectionReference userCollection =
      Firestore.instance.collection('userData');

  // dont update the fcm token on regular updates
  Future updateUserData(double latitude, double longitude, bool alerter ,bool alerted, bool responder, String alertType, int alertLevel) async {
    return await userCollection.document(uid).updateData({
      'latitude': latitude,
      'longitude': longitude,
      'alerter': alerter,
      'alerted': alerted,
      'responder': responder,
      'alertType': alertType,
      'alertLevel': alertLevel,
    });
  }
  Future updateUserDataOnRegister(double latitude, double longitude, bool alerter ,bool alerted, bool responder, String alertType, int alertLevel) async {
    return await userCollection.document(uid).setData({
      'fcmToken':fcmToken,
      'latitude': latitude,
      'longitude': longitude,
      'alerter': alerter,
      'alerted': alerted,
      'responder': responder,
      'alertType': alertType,
      'alertLevel': alertLevel,
    });
  }

  // get userData objects from snapshot. We won't parse the fcm token as we can always get it locally if required.
  List<UserData> _userDataFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserData(
        uid: doc.documentID,
        latitude: doc.data['latitude'].toDouble() ?? 0.0, // if 'latitude doesnt exist
        longitude: doc.data['longitude'].toDouble() ?? 0.0,
        alerter: doc.data['alerter'],
        alerted: doc.data['alerted'],
        responder: doc.data['responder'],
        alertType: doc.data['alertType'],
        alertLevel: doc.data['alertLevel'],
      );
    }).toList();
  }

  // get user's data stream
  Stream<List<UserData>> get userDataStream {
    return userCollection.snapshots().map(_userDataFromSnapshot);
  }

  setFcmToken(token){
    this.fcmToken = token;
  }
}
