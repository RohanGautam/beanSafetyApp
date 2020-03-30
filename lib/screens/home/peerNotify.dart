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
              alertTypeSelector(),
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
            
              Text(showNotificationStatus(userData, currentUserData)),
              
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

  Widget alertTypeSelector() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            emergencyOptionButton("Harassment", 'assets/assault.png'),
            emergencyOptionButton("Health", 'assets/health.png'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            emergencyOptionButton("Accident", 'assets/accident.png'),
            emergencyOptionButton("Fire", 'assets/fire.png'),
          ],
        )
      ],
    );
  }

  var selectedBorderColor = Color(0xFFF05A22);
  var borderRadius = BorderRadius.circular(30.0);
  var colorMap = {
    'harassment' : Color(0xFFF05A22),
    'health' : Color(0xFFF05A22),
    'accident' : Color(0xFFF05A22),
    'fire' : Color(0xFFF05A22),
  };
  var currentAlertType;
  updateBorderColor(String emName){
    colorMap.forEach((alertType, color){
      if(alertType == emName.toLowerCase()){
        setState(() {
          colorMap[alertType] = Colors.blue[400];          
        });
      }
      else{
        setState(() {
          colorMap[alertType] = Color(0xFFF05A22);                
        });
      }
    });
  }
  Color getBorderColor(String emName){
    return colorMap[emName.toLowerCase()];
  }

  Widget emergencyOptionButton(String emName, String imagePath) {
    return Container(
      height: 190,
      width: 190,
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          print("${emName} tapped");
          currentAlertType = emName;
          updateBorderColor(emName);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: getBorderColor(emName),
              style: BorderStyle.solid,
              width: 5.0,
            ),
            color: Colors.red[100],
            borderRadius: borderRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Image.asset(
                  imagePath,
                  width: 120,
                  height: 120,
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Text(
                        emName.toUpperCase(),
                        style: TextStyle(
                          color: Color(0xFFF05A22),
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
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
