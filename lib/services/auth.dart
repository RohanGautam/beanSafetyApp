import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/services/database.dart';
import 'package:firebase_tutorial/services/pushNotification.dart';

class AuthService {
  // Will have all the methods to interact with firebase

  final FirebaseAuth _auth = FirebaseAuth.instance; // _ means it's private
  PushNotificationService pns = PushNotificationService();

  //Create custom user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    // getter fn's defined like this in dart
    // we want to listen for auth changes at the top level of the app thru this- using "Provider"
    // returns a firebase user when change in auth- sign in or out
    // note the fat arrow notation to define functions(optional)
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser); // stream of custom objects
  }

  // sign in: anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in: email, pw
  Future signInEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  // register: email, pw
  Future registerEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // initialize push notification service
      await pns.initialize();
      DatabaseService userDb = DatabaseService(uid: user.uid);
      userDb.setFcmToken(await pns.getDeviceToken());
      // create new document for user with uid
      await userDb.updateUserData(0.0, 0.0, false, false, false, "none", 0); // 'default' values

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
