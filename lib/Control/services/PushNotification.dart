import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

/// This class handles the push notification services that involve firebase.
/// It also defines callbacks on what happens once the notification payload is recieved from firebase.
/// The notifications themselves are triggered through a custom cloud function hosted on firebase, the code for which is 
/// present in `functions/lib/.index.ts` in the project root.
class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if(Platform.isIOS){
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    /// this is where we define the callbacks, ie, what to do when the notification on recieved in different situations.
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
  
  /// getter for getting the device token, which is a string tht firebase uses to uniquely indentify your device.
  getDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    return fcmToken;
  }

}