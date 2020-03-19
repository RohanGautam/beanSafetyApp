import 'package:cloud_firestore/cloud_firestore.dart';

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

  // get user's data stream
  Stream<QuerySnapshot> get userDataStream {
    return userCollection.snapshots();
  }
}
