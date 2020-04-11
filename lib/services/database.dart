import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/userData.dart';




/// This class handles all the FireStore database related functions(read and write).
/// It also provides a stream which we listen to in `Home.dart` (after login)
/// that notifies us every time user data has updated/ changed so we can reflect the most updated
/// value in our app.
class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  String fcmToken;  
  //collection reference: programatically creates 'userData' collection if it doesn't exist
  final CollectionReference userCollection =
      Firestore.instance.collection('userData');

  /// Perform a "regular" update.Because we dont want to update the fcm token on regular updates.
  /// Used in `peerNotify.dart` to update alert/alerted/responder status of various users.
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

  /// A one time update which happens when a new user registers. This stores the `fcm` token (used in firebase push notificatins.)
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

  /// parses data in FireStore into a list of custom `UserData` objects (see `models/UserData.dart`) 
  /// We won't parse the `fcm` token stored as it is used not by the app, but by the firebase cloud function
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

  /// user data change stream.
  /// This is the stream that widgets (like `home.dart`) listen to, to be notified of user data changes.
  /// 
  /// Returns a firebase user data snapshot, mapped to custom `UserData` object when change data triggered by any source.
  Stream<List<UserData>> get userDataStream {
    return userCollection.snapshots().map(_userDataFromSnapshot);
  }

  setFcmToken(token){
    this.fcmToken = token;
  }
}
