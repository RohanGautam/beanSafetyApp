import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/screens/authenticate/authenticate.dart';
import 'package:firebase_tutorial/screens/home/home.dart';
import 'package:firebase_tutorial/services/pushNotification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  final PushNotificationService _pns = PushNotificationService();
  @override
  Widget build(BuildContext context) {
    _initializeNotifications();
    final user = Provider.of<User>(context); // <User> to specify which stream to listen to
    //return either home or authenticate widget(screens)
    return user==null ? Authenticate(): Home();
  }

  _initializeNotifications() async {
    await _pns.initialize();
  }
}