import 'package:firebase_tutorial/Wrapper.dart';
import 'package:firebase_tutorial/Control/services/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:firebase_tutorial/Entity/User.dart';

void main() => runApp(MyApp());

/// This is our root widget.
/// It is mainly a parent for `Wrapper.dart`.
/// It's function is to initialize the Authentication Stream so that it's child,
/// `Wrapper.dart` can perform certain actions on authentication changes.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      // calling the "getter" in auth.dart. We are now listening to the stream, listening for users!
      // Now, any child can access data provided by the stream.
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
