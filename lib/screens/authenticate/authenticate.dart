import 'package:firebase_tutorial/screens/authenticate/register.dart';
import 'package:firebase_tutorial/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  void toggleSignIn(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignIn(toggleSignIn: toggleSignIn,);
    } else {
      return Register(toggleSignIn: toggleSignIn,);
    }
  }
}