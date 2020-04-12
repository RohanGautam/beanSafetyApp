import 'package:firebase_tutorial/Control/services/AuthenticationService.dart';
import 'package:firebase_tutorial/Widget/LoadingScreen.dart';
import 'package:firebase_tutorial/Widget/TextInputDecoration.dart';

import 'package:flutter/material.dart';

/// This class is the SignIn UI. It contains the UI elements for
/// the `SignIn` page, for example the text feilds to enter the username and passoword.
/// It also performs basic form validation, for example checking if the email is valid, the password
/// is of specified length, etc.
/// Once the form is submitted, it uses the authentication service (in `services/AuthorisationService.dart`)
/// to communicate with firebase and sign in the user.
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
  // controls if loading screen is shown. The loading screen is shown while we check if the account is valid or not.
  bool loading = false;
  // text field state
  String email = "";
  String password = "";
  String registerError = "";

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Text("Sign in!"),
              backgroundColor: Colors.red[400],
              actions: <Widget>[
                FlatButton.icon(
                  onPressed: () {
                    /// This is calling `authenticate.dart`'s `toggleSignIn` function which we passed to it,
                    /// to switch to the register page.
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
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/jelly_beans.png',
                        scale: 4.5,
                      ),
                      Text(
                        'Welcome back to B.E.A.N.S !',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600]),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          // null if valid, helper text if invalid
                          return val.isEmpty ? "Enter email" : null;
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        decoration: textInputDecoration("Enter Email"),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (val) {
                          // null if valid, helper text if invalid
                          return val.length < 6
                              ? "Enter password atleast 6 characters long"
                              : null;
                        },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        decoration: textInputDecoration("Enter Password"),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Sign In",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white)),
                        ),
                        color: Colors.red[300],
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        onPressed: () async {
                          //login with email and pw
                          if (_formKey.currentState.validate()) {
                            // show loading before await.
                            setState(() {
                              loading = true;
                            });
                            var result = await _auth.signInEmailAndPassword(
                                email, password);
                            if (result == null) {
                              setState(() {
                                registerError =
                                    "Could not sign in with given credentials";
                                loading = false;
                              });
                            } else {
                              setState(() {
                                registerError = "";
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        registerError,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
