import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Will have all the methods to interact with firebase

  final FirebaseAuth _auth = FirebaseAuth.instance; // _ means it's private

  // sign in: anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in: email, pw
  // register: email, pw
  // sign Out

}