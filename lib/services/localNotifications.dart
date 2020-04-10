import 'package:firebase_tutorial/screens/home/alertMe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_tutorial/screens/home/home.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
var initialisationSettingsAndroid;
var initialisationSettingsIOS;
var initialisationSettings;

//Call this function to show notifications. Title and body is the information you would want to tell
void showNotification(int id, String title, String body) async {
  await _demoNotification(id, title, body);
}

//Details of showNotification
Future<void> _demoNotification(int id, String title, String body) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_ID',
    'channel name',
    'channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ticker: 'test ticker',
  );
  var iOSChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      id, title, body, platformChannelSpecifics,
      payload: 'test payload');
}

//to initialise, should be placed when the app first logs on
void initialise() {
  initialisationSettingsAndroid = new AndroidInitializationSettings('app_icon');
  initialisationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  initialisationSettings = new InitializationSettings(
      initialisationSettingsAndroid, initialisationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initialisationSettings,
      onSelectNotification: onSelectNotification);
}

//When the Notification is clicked, Weather Map shows
Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint("Notification payload: $payload");
  }
  await Navigator.push(
      HomeState().context, new MaterialPageRoute(builder: (context) => AlertMeUI()));
}

//For IOS
Future onDidReceiveLocalNotification(
    int id, String title, String body, String payload) async {
  await showDialog(
    context: HomeState().context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text("Ok"),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pop(await Navigator.push(
                context, MaterialPageRoute(builder: (context) => AlertMeUI())));
          },
        ),
      ],
    ),
  );
}