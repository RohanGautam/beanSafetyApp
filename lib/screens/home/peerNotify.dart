import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutorial/services/currentLocation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_tutorial/services/database.dart';

class PeerNotify extends StatefulWidget {
  @override
  _PeerNotifyState createState() => _PeerNotifyState();
}

class _PeerNotifyState extends State<PeerNotify> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Peer Notify"),
      ),
      body: Container(
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
                          "User ${userData[index].uid}\nLatitude : ${userData[index].latitude}\nLongitude : ${userData[index].longitude}\nalerter : ${userData[index].alerter}\nalertType : ${userData[index].alertType}"),
                    );
                  },
                ),
              ),
              RaisedButton(
                child: Text("Send location to db"),
                onPressed: () async {
                  var result = await DatabaseService(uid: user.uid)
                      .updateUserData(
                          currentLat,
                          currentLng,
                          currentUserData.alerter,
                          currentUserData.alerted,
                          currentUserData.responder,
                          currentUserData.alertType,
                          currentUserData.alertLevel);
                  print(result);
                },
              ),
              RaisedButton(
                child: Text("Reset all data"),
                onPressed: () async {
                  userData.forEach((data) async {
                    await DatabaseService(uid: data.uid).updateUserData(
                        0.0, 0.0, false, false, false, "none", 0);
                  });
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
                  var alertType = "Medical need";
                  var alertLevel = 3;
                  var r1 = await DatabaseService(uid: user.uid).updateUserData(
                      currentUserData.latitude,
                      currentUserData.longitude,
                      true,
                      currentUserData.alerted,
                      currentUserData.responder,
                      alertType,
                      alertLevel);
                  // mark everyone else as alerted TODO: alert only those nearby
                  userData.forEach((data) async {
                    if (data.uid != user.uid) {
                      print("Alert- updating ${data.uid} ");
                      var r2 = await DatabaseService(uid: data.uid)
                          .updateUserData(
                              data.latitude,
                              data.longitude,
                              data.alerter,
                              true,
                              data.responder,
                              data.alertType,
                              data.alertLevel);
                      print(r2);
                      print(
                          'curr database location ${currentUserData.latitude}, ${currentUserData.longitude}');
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
              Text(showNotificationStatus(userData, currentUserData)),
              SizedBox(height: 50),
              RaisedButton(
                child: Text(
                  "Respond",
                  style: TextStyle(fontSize: 50),
                ),
                onPressed: () async {
                  // mark self as responder
                  var alertType = "Medical need";
                  var alertLevel = 3;
                  var r1 = await DatabaseService(uid: user.uid).updateUserData(
                    currentUserData.latitude,
                    currentUserData.longitude,
                    currentUserData.alerter,
                    currentUserData.alerted,
                    true,
                    alertType,
                    alertLevel,
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String showNotificationStatus(
      List<UserData> userData, UserData currentUserData) {
    var alertStatus = "Idle";
    if (currentUserData.alerted) {
      userData.forEach((data) {
        if (data.alerter == true) {
          alertStatus =
              "Alerted!!!! type ${data.alertType}, level ${data.alertLevel}";
        }
      });
    }
    userData.forEach((data) {
      if (data.responder == true && (data.uid != currentUserData.uid)) {
        alertStatus += "\nResponder ${data.uid} on the way";
      }
    });
    return alertStatus;
  }
}
