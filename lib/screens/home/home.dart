import 'package:firebase_tutorial/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              // this will update the stream, and we'll see the authentication page
              // as the wrapper will react to the null event
              await _auth.signOut();
            },
            icon: Icon(Icons.person),
            label: Text("Logout"),
          )
        ],
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("ignore me"),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
