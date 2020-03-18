import 'package:firebase_tutorial/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Sign in!"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: RaisedButton(
          child: Text("Sign in anon"),
          onPressed: () async {
            var result = await _auth.signInAnon();
            if (result==null){
              print("Error");
            }
            else{
              print("Sign in success! $result");
            }
          },
        ),
      ),
    );
  }
}
