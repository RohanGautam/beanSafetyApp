import 'package:firebase_tutorial/models/userData.dart';
import 'package:firebase_tutorial/screens/home/mapDirections.dart';
import 'package:firebase_tutorial/screens/home/peerNotify.dart';
import 'package:firebase_tutorial/services/auth.dart';
import 'package:firebase_tutorial/services/database.dart';
import 'package:firebase_tutorial/shared/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'alertMe.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      // now we can access the data is descendant widgets.
      value: DatabaseService().userDataStream,
      child: Scaffold(
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
            child: Column(
              children: <Widget>[
                buttonInSizedBox('Alert Me', MaterialPageRoute(builder: (context) => AlertMe())),
                buttonInSizedBox('Emergency Services', MaterialPageRoute(builder: (context) => AlertMe())),
                buttonInSizedBox(
                  'Peer Notification',
                  MaterialPageRoute(
                      builder: (context) => StreamProvider.value(
                            value: DatabaseService().userDataStream,
                            child: PeerNotify(),
                          )),
                ),
                buttonInSizedBox('Emergency contacts', MaterialPageRoute(builder: (context) => AlertMe())),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonInSizedBox(var text, var mpr) {
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        SizedBox(
            width: 200.0,
            height: 70.0,
            child: CustomButton(text: text, mpr: mpr))
      ],
    );
  }
}
