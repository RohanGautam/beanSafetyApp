import 'package:firebase_tutorial/screens/authenticate/authenticate.dart';
import 'package:firebase_tutorial/screens/home/home.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //return either home or authenticate widget(screens)
    return Home();
  }
}