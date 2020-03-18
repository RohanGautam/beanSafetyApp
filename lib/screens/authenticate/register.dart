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
          key: _formKey, //associate a global key with our form (to track it for validation)
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
                child: Text("Register"),
                onPressed: () async {
                  //login with email and pw
                  // validate : runs validators we defined for each form field
                  if(_formKey.currentState.validate()){
                    var result = await _auth.registerEmailAndPassword(email, password);
                    if(result==null){
                      setState(() {
                        registerError = "Invalid email supplied";
                      });
                    }
                    else{
                      setState(() {
                        registerError="";
                      });
                    }
                    // no need  to go to homepage in else
                    // The register will result in the stram containing the user.
                    // So, the parent will go to the homepage on it's own.
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