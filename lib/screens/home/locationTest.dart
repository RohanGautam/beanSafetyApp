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
  var location = UserData(latitude: 0, longitude: 0);

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<List<UserData>>(context);
  User user = Provider.of<User>(context);
    // userData.forEach((data) {
    //   print("lat : ${data.latitude}");
    //   print("lng : ${data.longitude}");
    // });

    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Get location"),
              onPressed: () async {
                location = await CurrentLocation().getCurrentLocation();
                if (location != null) {
                  setState(() {
                    locationDisplay =
                        "${location.latitude}, ${location.longitude}";
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
            Text("From database"),
            Expanded( // to have listview inside col w/o errors
              child: ListView.builder(
                itemCount: userData.length,
                itemBuilder: (context, index) {
                  print("lat : ${userData[index].latitude}");
                  print("lng : ${userData[index].longitude}");
                  return Center(
                    child: Text(
                        "Latitude : ${userData[index].latitude}\nLongitude : ${userData[index].longitude}"),
                  );
                },
              ),
            ),
            RaisedButton(
              child: Text("Send location"),
              onPressed: () async {
                var result = await DatabaseService(uid: user.uid).updateUserData(location.latitude, location.longitude);
                print(result);
              },
            ),
          ],
        ),
      ),
    );
  }
}
