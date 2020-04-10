import 'package:firebase_tutorial/services/auth.dart';
import 'package:firebase_tutorial/shared/loading.dart';
import 'package:firebase_tutorial/shared/authTextfeildDecoration.dart';
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
  final _formKey = GlobalKey<FormState>();

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
              backgroundColor: Colors.red[400],
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
                key:
                    _formKey, //associate a global key with our form (to track it for validation)
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/jelly_beans.png',
                        scale: 4.5,
                      ),
                      Text(
                        'Welcome to B.E.A.N.S !',
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
                        obscureText: true,
                        decoration: textInputDecoration("Enter Password"),
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Register",style: TextStyle(fontSize: 25, color: Colors.white)),
                        ),
                        color: Colors.red[300],
                        shape: new RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        onPressed: () async {
                          //register with email and pw
                          // validate : runs validators we defined for each form field
                          if (_formKey.currentState.validate()) {
                            // show loading before await.
                            setState(() {
                              loading = true;
                            });
                            var result = await _auth.registerEmailAndPassword(
                                email, password);
                            if (result == null) {
                              setState(() {
                                registerError = "Invalid email supplied";
                                loading = false;
                              });
                            }
                            // no need  to go to homepage in else
                            // The register will result in the stram containing the user.
                            // So, the parent will go to the homepage on it's own.
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
