import 'package:firebase_tutorial/models/userData.dart';
import 'package:firebase_tutorial/screens/home/emergencyContacts.dart';
import 'package:firebase_tutorial/screens/home/peerNotify.dart';
import 'package:firebase_tutorial/services/auth.dart';
import 'package:firebase_tutorial/services/database.dart';
import 'package:firebase_tutorial/shared/RoundIconButton.dart';
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
          title: Text("Home"),
          centerTitle: true,
          backgroundColor: Colors.red[400],
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
        body: Stack(
          children: <Widget>[
            Positioned(
                width: MediaQuery.of(context).size.width,
                top: MediaQuery.of(context).size.width * 0.08,//TRY TO CHANGE THIS **0.30** value to achieve your goal
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  child:Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/jelly_beans.png',
                          scale: 4.5,
                        ),
                        SizedBox(height: 20.0),
                        Text('B.E.A.N.S.',
                            style: TextStyle(
                                fontSize: 35.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[600]
                            )
                        ),
                        SizedBox(height: 10.0,),
                        Text('Bi-directional Emergency And Notification System',
                          style: TextStyle(
                            color: Colors.grey
                          ),
                        )
                      ]
                  ),
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 280.0, 10.0, 0.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                //padding: const EdgeInsets.all(10.0),
                //shrinkWrap: true,
                children: <Widget>[
                  RoundIconButton(
                    icon: IconData(57347, fontFamily: 'MaterialIcons'),
                    mpr:
                    MaterialPageRoute(
                        builder: (context) => EmergencyContacts()),
                    text: 'ALERT ME',
                  ),
                  RoundIconButton(
                    icon: IconData(57551, fontFamily: 'MaterialIcons'),
                    mpr:
                    MaterialPageRoute(
                      builder: (context) => StreamProvider.value(
                            value: DatabaseService().userDataStream,
                            child: PeerNotify(),
                          )),
                    text: 'ALERT OTHERS',
                  ),
                  RoundIconButton(
                    icon: IconData(58727, fontFamily: 'MaterialIcons'),
                    mpr:
                    MaterialPageRoute(
                        builder: (context) => EmergencyContacts()),
                    text: 'EMERGENCY SERVICES',
                  ),

                  RoundIconButton(
                    icon: IconData(57576, fontFamily: 'MaterialIcons'),
                    mpr:
                    MaterialPageRoute(
                        builder: (context) => EmergencyContacts()),
                    text: 'EMERGENCY CONTACTS',
                  ),
                ],
              ),
            )
          ],

        )

      ),
    );
  }
}
