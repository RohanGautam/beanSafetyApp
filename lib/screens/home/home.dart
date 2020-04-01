import 'package:firebase_tutorial/models/userData.dart';
import 'package:firebase_tutorial/screens/home/mapDirections.dart';
import 'package:firebase_tutorial/screens/home/peerNotify.dart';
import 'package:firebase_tutorial/services/auth.dart';
import 'package:firebase_tutorial/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                RaisedButton(
                    child: Text("Peer Notification"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StreamProvider.value(
                                  value: DatabaseService().userDataStream,
                                  child: PeerNotify(),
                                )),
                      );
                    }),
                RaisedButton(
                    child: Text("Google Maps"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapDirections(
                                    sLat: 45.521563,
                                    sLng: -122.677433,
                                    dLat: 45.621563,
                                    dLng: -122.777433,
                                  )));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
