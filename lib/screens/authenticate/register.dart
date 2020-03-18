import 'package:firebase_tutorial/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleSignIn;
  //Constructor to accept arguments
  Register({this.toggleSignIn});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();

  // text field state
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Register!"),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toggleSignIn();
            },
            icon: Icon(Icons.person),
            label: Text("Sign In"),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text("Register"),
                onPressed: () async {
                  //login with email and pw
                  print("$email \n$password");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}