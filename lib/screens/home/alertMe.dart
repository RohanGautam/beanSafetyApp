import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class AlertMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'Alert Me'),
      body: AlertMeDetails(title: 'Alert Me'),
    );
  }
}

class AlertMeDetails extends StatefulWidget {
  AlertMeDetails({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _AlertMeDetailsState createState() => _AlertMeDetailsState();
}

class _AlertMeDetailsState extends State<AlertMeDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreferencePage([
        PreferenceTitle('Manage Alerts'),
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
        PreferenceTitle('View Maps'),
        PreferencePageLink(
          'Dengue',
          leading: Icon(Icons.map),
          trailing: Icon(Icons.keyboard_arrow_right),
          page: PreferencePage([]),
        ),
        PreferencePageLink('Weather',
            leading: Icon(Icons.map),
            trailing: Icon(Icons.keyboard_arrow_right),
            page: PreferencePage([])),
      ]),
    );
  }
}
