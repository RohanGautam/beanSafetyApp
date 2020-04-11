import 'package:firebase_tutorial/Control/screens/home/alertMe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_tutorial/Control/screens/home/home.dart';

/// This is the control class for push notifications sent locally
/// [localNotifications] can be used when the event to trigger the notification is in the current user's app
/// Import this class into any other files and call showNotifications to send notifications locally

/// Create instance of FlutterLocalNotificationsPlugin
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
/// Local Notification Settings to be initialised for Android
var initialisationSettingsAndroid;
/// Local Notification Settings to be initialised for IOS
var initialisationSettingsIOS;
/// Generic Local Notification Settings to be initialised
var initialisationSettings;

/// Call [showNotification] for Local Notifications anywhere in the app after home.dart is initialised
/// This will show up as a push notification
/// [id] identifies the notification
/// [title] and [body] will be displayed on the notification
void showNotification(int id, String title, String body) async {
  await _demoNotification(id, title, body);
}

/// Sets up the details of the notification and shows the notification
/// Use [showNotification] if you want a local notification
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

/// Initialise Local Notifications
/// [initialise] is recommended to be called in home.dart
/// ['app_icon'] is the icon displayed in the notification
/// ['app_icon'] corresponds to the app_icon.png in the android/app/src/main/res/drawable file
/// Ensure app_icon.png has a transparent background
void initialise() {
  initialisationSettingsAndroid = new AndroidInitializationSettings('app_icon');
  initialisationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  initialisationSettings = new InitializationSettings(
      initialisationSettingsAndroid, initialisationSettingsIOS);
  flutterLocalNotificationsPlugin.initialize(initialisationSettings,
      onSelectNotification: onSelectNotification);
}

/// When the notification is clicked, the user will be directed to [AlertMeUI()]
Future onSelectNotification(String payload) async {
  if (payload != null) {
    debugPrint("Notification payload: $payload");
  }
  await Navigator.push(
      HomeState().context, new MaterialPageRoute(builder: (context) => AlertMeUI()));
}

/// This is the dialog shown in IOS
/// When the notification is clicked, the user will be directed to [AlertMeUI()]
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