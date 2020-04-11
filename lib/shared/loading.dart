import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// A loading screen. This is shown when there is a process that we are waiting for,
/// which takes time. For example, it is used in `register.dart`, and shown when Firebase is registering the user.
/// It is also used in `sign_in.dart`, and in `emergencyServiceMap.dart` between various asyncronous processes.
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[100],
      child: Center(
        child: SpinKitFoldingCube(
          color: Colors.brown[500],
          size: 50.0,
        ),
      ),
    );
  }
}
