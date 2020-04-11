import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/services/database.dart';
import 'package:firebase_tutorial/services/pushNotification.dart';


/// This is the class that handles all the authentication communications with Firebase.
/// Contains functions used in the authentication files present in `lib/screens/authenticate`.
class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance; // _ means it's private
  PushNotificationService pns = PushNotificationService();

  /// To Create custom `User` obj (based on our user model in `lib/models`) based on firebase user.
  /// Basically, to parse the firebase response into a custom object which only contains a subset 
  /// of the information we need.
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  /// auth change user stream.
  /// This is the stream that parent widgets (like `main.dart`) listen to, to be notified of authentication changes.
  /// 
  /// Returns a firebase user, mapped to custom `User` object when change in auth- sign in or out.
  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser); // stream of custom objects
  }

  // sign in anonymously. Not used but Could be a future feature in cases of real emergencies, so keeping for time being.
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

  /// Sign in with specified `email` and `password` using Firebase Auth.
  /// Firebase checks if such a user exists, and returns the `User` ubject if it does and `null` otherwise.
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
  /// register with specified `email` and `password` using Firebase Auth.
  /// We create an entry for this new user in our Firestore Database, using the `DatabaseService`.
  /// When the user is registering, is the time we also get and store the users `fcm` token.
  /// This token is used by firebase to uniquely identify a device, and is used for sending targeted push notifications
  /// to users during the peer alerting process.
  Future registerEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      // initialize push notification service
      await pns.initialize();
      DatabaseService userDb = DatabaseService(uid: user.uid);
      userDb.setFcmToken(await pns.getDeviceToken());
      // create new document for user with uid
      await userDb.updateUserDataOnRegister(0.0, 0.0, false, false, false, "none", 0); // 'default' values

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  /// Sign out of the current session. This sign out event is also reflected in the auth stream, 
  /// so we show signin and register pages once this happens.
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
