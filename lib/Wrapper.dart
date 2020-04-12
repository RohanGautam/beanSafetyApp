import 'Entity/User.dart';
import 'Control/services/Authentication.dart';
import 'Control/screens/HomePageUI.dart';
import 'Control/services/PushNotification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This class is responsible for taking actions depending on the stream changes.
/// `Provider` is used to listen for changes lower in the widget tree, eg, in the authentication part here.
/// We listen to these changes using a stream.
/// We show the `Home` screen if we have a valid user instance (meaning login was successful),
/// and continue showing the Signin/Register page if user instance gotten from the stream is null.
class Wrapper extends StatelessWidget {
  final PushNotificationService _pns = PushNotificationService();
  @override
  Widget build(BuildContext context) {
    // initialise the firebase pushnotification service. Used in peer notification system.
    _initializeNotifications();
    final user = Provider.of<User>(
        context); // <User> to specify which stream to listen to
    //return either home or authenticate widget(screens)
    return user == null ? Authenticate() : HomePageUI();
  }

  _initializeNotifications() async {
    await _pns.initialize();
  }
}
