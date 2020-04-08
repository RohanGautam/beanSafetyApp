import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      // called when you are using app and you get a notif
      onMessage: (Map<String,dynamic> message) async{
        print('onMessage : $message');
      },
      // when app is closed and u get a notif
      onLaunch: (Map<String,dynamic> message) async{
        print('onLaunch : $message');
      },
      //when app is in background and you get a notif
      onResume: (Map<String,dynamic> message) async{
        print('onResume : $message');
      },
    );
  }

  getDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    return fcmToken;
  }

}