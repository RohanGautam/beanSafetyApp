import 'package:firebase_tutorial/screens/wrapper.dart';
import 'package:firebase_tutorial/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      // calling the "getter" in auth.dart. We are now listening to the stream!
      // Now, any child can access data provided by the stream.
      value: AuthService().user, 
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
