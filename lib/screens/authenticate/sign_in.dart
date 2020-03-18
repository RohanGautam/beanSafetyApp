import 'package:firebase_tutorial/services/auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleSignIn;
  //Constructor to accept arguments
  SignIn({this.toggleSignIn});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  // text field state
  String email = "";
  String password = "";
  String registerError="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Sign in!"),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toggleSignIn();
            },
            icon: Icon(Icons.person),
            label: Text("Register"),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              TextFormField(
                validator: (val){
                  // null if valid, helper text if invalid
                  return val.isEmpty ? "Enter email" : null;
                },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: (val){
                  // null if valid, helper text if invalid
                  return val.length<6 ? "Enter password atleast 6 characters long" : null;
                },
                onChanged: (val) {
                  setState(() {
                    password = val;
                  });
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text("Sign In"),
                onPressed: () async {
                  //login with email and pw
                  if(_formKey.currentState.validate()){
                    var result = await _auth.signInEmailAndPassword(email, password);
                    if(result==null){
                      setState(() {
                        registerError = "Could not sign in with given credentials";
                      });
                    }
                    else{
                      setState(() {
                        registerError="";
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12,),
              Text(registerError, style: TextStyle(color: Colors.red),)
            ],
          ),
        ),
      ),
    );
  }
}
