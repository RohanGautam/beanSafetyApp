import 'package:firebase_tutorial/screens/authenticate/register.dart';
import 'package:firebase_tutorial/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

/// This is a parent class for `SignIn` and `Register` authentication classes.
/// It contains a function called `toggleSignIn` that it's children can call 
/// to toggle which authentication screen is being displayed. Calling a parents function to switch
/// screens in the parent's build function is an alternative to using `Navigator.push() `
/// and other stack-based screen transition variants.
class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  // this variable controls which screen- signin or register- is shown. By default, signin is shown.
  bool showSignIn = true;

  void toggleSignIn(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  /// display authentication screen based on `showSignIn`'s value
  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleSignIn: toggleSignIn,);
    } else {
      return Register(toggleSignIn: toggleSignIn,);
    }
  }
}