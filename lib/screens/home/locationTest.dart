import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutorial/services/currentLocation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_tutorial/services/database.dart';

class LocationTest extends StatefulWidget {
  @override
  _LocationTestState createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  String locationDisplay = '';
  // var location = {'latitude': 0.0, 'longitude': 0.0};
  var currentLat = 0.0;
  var currentLng = 0.0;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<List<UserData>>(context);
    User user = Provider.of<User>(context);
    UserData currentUserData;
    userData.forEach((data) {
      if (data.uid == user.uid) {
        currentUserData = data;
      }
    });

    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Get location"),
              onPressed: () async {
                var location = await CurrentLocation().getCurrentLocation();

                if (location != null) {
                  setState(() {
                    currentLat = location['latitude'];
                    currentLng = location['longitude'];
                    locationDisplay = "${currentLat}, ${currentLng}";
                    print(locationDisplay);
                  });
                } else {
                  setState(() {
                    locationDisplay = "unable to get location :(";
                  });
                }
              },
            ),
            Text(
              locationDisplay,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text("Location of all users:"),
            Expanded(
              // to have listview inside col w/o errors
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  // print("lat : ${userData[index].latitude}");
                  // print("lng : ${userData[index].longitude}");
                  return Center(
                    child: Text(
                        "User ${userData[index].uid}\nLatitude : ${userData[index].latitude}\nLongitude : ${userData[index].longitude}\nalerter : ${userData[index].alerter}"),
                  );
                },
              ),
            ),
            RaisedButton(
              child: Text("Send location to db"),
              onPressed: () async {
                var result = await DatabaseService(uid: user.uid)
                    .updateUserData(currentLat, currentLng, currentUserData.alerter, currentUserData.alerted, currentUserData.responder);
                print(result);
              },
            ),
            RaisedButton(
              child: Text(
                "Alert",
                style: TextStyle(fontSize: 50),
              ),
              onPressed: () async {
                print("Alert- updating statuses: ");
                // mark self as alerter
                var r1 = await DatabaseService(uid: user.uid).updateUserData(
                    currentUserData.latitude, currentUserData.longitude, true, currentUserData.alerted, currentUserData.responder);
                // mark everyone else as alerted TODO: alert only those nearby
                userData.forEach((data) async {
                  if(data.uid!=user.uid){
                    print("Alert- updating ${data.uid} ");
                    var r2 = await DatabaseService(uid: data.uid).updateUserData(data.latitude, data.longitude, data.alerter, true, data.responder);
                    print(r2);
                print('curr database location ${currentUserData.latitude}, ${currentUserData.longitude}');
                  }
                });
                print("Alert- current info: ");
                // UserData
                userData.forEach((data) {
                  if (data.uid == user.uid) {
                    print("Current user:\n\t${data.uid}");
                  } else {
                    print("Other users:\n\t${data.uid}");
                  }
                  print("\tlat : ${data.latitude}");
                  print("\tlng : ${data.longitude}");
                  print("\talerter : ${data.alerter}");
                  print("\talerted : ${data.alerted}");
                  print("\tresponder : ${data.responder}");
                });
              },
            ),
            SizedBox(height: 100),
            Text(currentUserData.alerted ? "Alerted!!!!" : "Idle"),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
