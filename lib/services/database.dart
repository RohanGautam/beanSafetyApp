import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/userData.dart';
class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //collection reference: programatically creates 'userData' collection if it doesn't exist
  final CollectionReference userCollection =
      Firestore.instance.collection('userData');

  Future updateUserData(double latitude, double longitude) async {
    return await userCollection.document(uid).setData({
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  // get userData objects from snapshot
  List<UserData> _userDataFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserData(
        uid: doc.documentID,
        latitude: doc.data['latitude'].toDouble() ?? 0.0, // if 'latitude doesnt exist
        longitude: doc.data['longitude'].toDouble() ?? 0.0
      );
    }).toList();
  }

  // get user's data stream
  Stream<List<UserData>> get userDataStream {
    return userCollection.snapshots().map(_userDataFromSnapshot);
  }
}
