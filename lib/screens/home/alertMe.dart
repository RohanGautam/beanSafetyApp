import 'package:firebase_tutorial/services/Clusters.dart';
import 'package:firebase_tutorial/services/WeatherDBMS.dart';
import 'package:firebase_tutorial/services/localNotifications.dart';
import 'package:firebase_tutorial/shared/RoundIconButton.dart';
import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:firebase_tutorial/services/Weather.dart';
import 'package:firebase_tutorial/services/WeatherDBMS.dart' as wdbms;
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';


/// This class contains the UI for the `AlertMe` page.
/// It consists of two switch toggles to enable/disable notifications desired by the user.
/// It also calls two map services - allowing you to view dengue clusters and allowing you
/// to view weather conditions near your current location.
class AlertMeUI extends StatefulWidget {
  @override
  _AlertMeUIState createState() => _AlertMeUIState();
}

class _AlertMeUIState extends State<AlertMeUI> {
  WeatherDBMS weatherStuff;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'Alert Me'),
      body: PreferencePage([
        SizedBox(height: 50),
        SizedBox(
            child: Image.asset(
              'assets/siren.png',
              scale: 3.0,
            ),
            height: 120),
        SizedBox(height: 20.0),
        Center(
          child: Text('Choose preferred alerts / Check cluster maps',
              style: TextStyle(fontSize: 15.0, color: Colors.grey)),
        ),
        SizedBox(height: 10),
        PreferenceTitle('Manage Alerts',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.red[700])),
        SwitchPreference(
          'Dengue',
          'dengue_alert',
          defaultVal: true,
          onEnable: () async {
            // Write something in Firestore or send a request
            await Future.delayed(Duration(seconds: 1));
          },
          onDisable: () async {
            // Write something in Firestore or send a request
            await Future.delayed(Duration(seconds: 1));

            // No Connection? No Problem! Just throw an Exception with your custom message...
            //throw Exception('No Connection');
          },
        ),
        SwitchPreference(
          'Weather',
          'weather_alert',
          defaultVal: true,
          onEnable: () async {
            wdbms.weatherEnabled = true;
            await Future.delayed(Duration(seconds: 1));
            wdbms.register();
          },
          onDisable: () async {
            wdbms.weatherEnabled = false;
            await Future.delayed(Duration(seconds: 1));
            wdbms.unregister();
            // Write something in Firest
            // ore or send a request
            // No Connection? No Problem! Just throw an Exception with your custom message...
            //throw Exception('No Connection');
          },
        ),
        PreferenceTitle(
          'View Maps',
          style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.red[700]),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundIconButton(
                icon: IconData(58715, fontFamily: 'MaterialIcons'),
                mpr: MaterialPageRoute(builder: (context) => Clusters()),
                text: 'DENGUE',
              ),
              SizedBox(width: 60),
              RoundIconButton(
                icon: IconData(58045, fontFamily: 'MaterialIcons'),
                mpr: MaterialPageRoute(builder: (context) => Weather()),
                text: 'WEATHER',
              ),

              /// just to test the working of notification
              // RaisedButton(
              //   child: Text("notif"),
              //   onPressed: (){
              //     showNotification(0, "Random", "Notificationn");
              // })
            ],
          ),
        ),
      ]),
    );
  }
}
