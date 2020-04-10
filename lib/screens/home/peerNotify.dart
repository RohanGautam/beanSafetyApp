import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/models/userData.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutorial/services/currentLocation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_tutorial/services/database.dart';

import 'mapDirections.dart';

class PeerNotify extends StatefulWidget {
  @override
  _PeerNotifyState createState() => _PeerNotifyState();
}

class _PeerNotifyState extends State<PeerNotify> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String locationDisplay = '';
  // var location = {'latitude': 0.0, 'longitude': 0.0};
  var currentLat = 0.0;
  var currentLng = 0.0;
  String currentAlertType;
  int currentAlertLevel;

  @override
  Widget build(BuildContext context) {
    var buttonBorderRadius = BorderRadius.circular(50.0);
    final userData = Provider.of<List<UserData>>(context);
    User user = Provider.of<User>(context);
    UserData currentUserData;
    userData.forEach((data) {
      if (data.uid == user.uid) {
        currentUserData = data;
      }
    });
    DatabaseService userDb = DatabaseService(uid: user.uid);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("PEER NOTIFY"),
        centerTitle: true,
        backgroundColor: Colors.red[400],
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              userData.forEach((data) async {
                await DatabaseService(uid: data.uid)
                    .updateUserData(0.0, 0.0, false, false, false, "none", 0);
              });
            },
            icon: Icon(Icons.restore_from_trash),
            label: Text(""),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: <Widget>[
                alertTypeSelector(),
                alertLevelSlider(),
                RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Alert",
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                  color: Colors.orangeAccent,
                  shape: new RoundedRectangleBorder(
                    borderRadius: buttonBorderRadius,
                    side: BorderSide(color: Colors.brown, width: 5)
                  ),
                  // disable button via setting onpressed to null if we dont have needed values
                  onPressed: (currentAlertType == null ||
                          currentAlertLevel == null)
                      ? null
                      : () async {
                          print("Alert- updating location: ");
                          var _locres = await getAndUpdateLocation(
                              currentUserData, user, userDb);
                          print("Location got and updated : $_locres}");
                          print("Alert- updating statuses: ");
                          // mark self as alerter
                          var r1 = await userDb.updateUserData(
                              currentLat,
                              currentLng,
                              true,
                              currentUserData.alerted,
                              currentUserData.responder,
                              currentAlertType,
                              currentAlertLevel);
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
                          print("Alert- sending notification");
                          sendAlertNotification(
                              user.uid, currentAlertType, currentAlertLevel);
                        },
                ),
                Text(
                    showNotificationStatus(userData, currentUserData, _scaffoldKey)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if(currentUserData.alerted)
                    RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Respond",
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                      color: Colors.red[100],
                      shape: new RoundedRectangleBorder(
                        borderRadius: buttonBorderRadius,
                        side: BorderSide(color: Colors.brown, width: 5)
                      ),
                      onPressed: () async {
                        print("Respond- updating location: ");
                        var _locres = await getAndUpdateLocation(
                            currentUserData, user, userDb);
                        var r1 = await userDb.updateUserData(
                          currentUserData.latitude,
                          currentUserData.longitude,
                          currentUserData.alerter,
                          currentUserData.alerted,
                          true,
                          currentUserData.alertType,
                          currentUserData.alertLevel,
                        );
                      },
                    ),
                    if(currentUserData.responder)
                    RaisedButton(
                      child: Text("GO!"),
                      color: Colors.red[100],
                      shape: new RoundedRectangleBorder(
                        borderRadius: buttonBorderRadius,
                        side: BorderSide(color: Colors.brown, width: 5)
                      ),
                      onPressed: () {
                              var dLat, dLng;
                              userData.forEach((data) {
                                if (data.alerter == true) {
                                  dLat = data.latitude;
                                  dLng = data.longitude;
                                }
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MapDirections(
                                            sLat: currentLat,
                                            sLng: currentLng,
                                            dLat: dLat +
                                                0.1, //TODO : remove this, is for testing
                                            dLng: dLng + 0.1,
                                          )));
                            },
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getAndUpdateLocation(
      UserData currentUserData, User user, DatabaseService userDb) async {
    // get users location
    var location = await CurrentLocation().getCurrentLocation();
    if (location != null) {
      setState(() {
        currentLat = location['latitude'];
        currentLng = location['longitude'];
        locationDisplay = "${currentLat}, ${currentLng}";
        // print(locationDisplay);
      });
    } else {
      setState(() {
        locationDisplay = "unable to get location :(";
        return false;
      });
    }
    // update database
    var result;
    print("${currentLat}, ${currentLng}");
    result = await userDb.updateUserData(
        currentLat,
        currentLng,
        currentUserData.alerter,
        currentUserData.alerted,
        currentUserData.responder,
        currentUserData.alertType,
        currentUserData.alertLevel);
    print(result);

    if (result != null) {
      return true;
    } else {
      // print(result.e);
      return false;
    }
  }

  Widget alertLevelSlider() {
    return Column(
      children: <Widget>[
        Text(
          "\nAlert level",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        Slider(
          value: (currentAlertLevel ?? 0).toDouble(),
          min: 0,
          max: 5,
          divisions: 5,
          label: (currentAlertLevel ?? 0).toString(),
          activeColor: Colors.deepOrange[900],
          inactiveColor: Colors.deepOrange[100],
          onChanged: (val) {
            setState(() {
              currentAlertLevel = val.toInt();
              print(currentAlertLevel);
            });
          },
        ),
      ],
    );
  }

  Widget alertTypeSelector() {
    return Column(
      children: <Widget>[
        Text(
          "Issue:",
          style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
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

  var borderRadius = BorderRadius.circular(30.0);
  var colorMap = {
    'harassment': Color(0xFFF05A22),
    'health': Color(0xFFF05A22),
    'accident': Color(0xFFF05A22),
    'fire': Color(0xFFF05A22),
  };

  updateBorderColor(String emName) {
    colorMap.forEach((alertType, color) {
      if (alertType == emName.toLowerCase()) {
        setState(() {
          colorMap[alertType] = Colors.blue[400];
        });
      } else {
        setState(() {
          colorMap[alertType] = Color(0xFFF05A22);
        });
      }
    });
  }

  Color getBorderColor(String emName) {
    return colorMap[emName.toLowerCase()];
  }

  Widget emergencyOptionButton(String emName, String imagePath) {
    double deviceWidth = (MediaQuery.of(context).size.width / 2) - 40;
    return Container(
      height: deviceWidth,
      width: deviceWidth,
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
                  width: deviceWidth - 80,
                  height: deviceWidth - 80,
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
                          fontSize: 14,
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
      List<UserData> userData, UserData currentUserData, var scaffoldKey) {
    var alertStatus = "Idle";
    if (currentUserData.alerted && currentUserData.responder==false) {
      userData.forEach((data) {
        if (data.alerter == true) {
          alertStatus =
              "Alerted!!!! type ${data.alertType}, level ${data.alertLevel} location ${data.latitude}, ${data.longitude}";
          // scaffoldKey.currentState.showSnackBar(customSnackBar(alertStatus, () {
          //   scaffoldKey.currentState.hideCurrentSnackBar();
          // }));
        }
      });
    }
    userData.forEach((data) {
      if (data.responder == true && (data.uid != currentUserData.uid)) {
        alertStatus = "\nResponder ${data.uid} on the way";
      }
    });
    return alertStatus;
  }

  Widget customSnackBar(String text, var onPressed) {
    return SnackBar(
      content: Text(text),
      action: SnackBarAction(label: "Dismiss", onPressed: onPressed),
    );
  }

  sendAlertNotification(
      var from, var currentAlertType, var currentAlertLevel) async {
    final HttpsCallable notifyUser =
        CloudFunctions.instance.getHttpsCallable(functionName: 'notifyUser');
    var resp = await notifyUser.call(<String, dynamic>{
      'from': from,
      'alertType': currentAlertType,
      'alertLevel': currentAlertLevel
    });
    print("response from cloud function: ${resp.data}");
  }
}
