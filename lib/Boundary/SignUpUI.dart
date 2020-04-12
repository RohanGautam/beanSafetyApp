import 'package:firebase_tutorial/Control/services/AuthenticationService.dart';
import 'package:firebase_tutorial/Widget/LoadingScreen.dart';
import 'package:firebase_tutorial/Widget/TextInputDecoration.dart';
import 'package:flutter/material.dart';

/// This class is the Register UI. It contains the UI elements for
/// the `Register` page, for example the text feilds to enter the username and passoword.
/// It also performs basic form validation, for example checking if the email is valid, the password
/// is of specified length, etc.
/// Once the form is submitted, it uses the authentication service (in `services/AuthorisationService.dart`)
/// to communicate with firebase and Register the user.
///
/// Upon successful registration, we do not have to manually route to the `Home` page.
/// This is because when this happens, the Authentication stream provided by firebase(that we are listening to
/// in `main.dart` and `Wrapper.dart`) is updated automatically, and the nessessary screen transitions take place.
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

  // controls if loading screen is shown. The loading screen is shown while we register the user.
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
                  /// This is calling `authenticate.dart`'s `toggleSignIn` function which we passed to it,
                  /// to switch to the Sign in page.
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
                          child: Text("Register",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white)),
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
