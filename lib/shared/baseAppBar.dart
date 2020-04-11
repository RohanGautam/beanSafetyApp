import 'package:flutter/material.dart';

/// this class returns an AppBar with the desired `title`.
/// It also contains a home button, which leads you to the home page regardless of your position in the app.
/// It is used across majority of the screens in the app, apart from ones where a certain custom `AppBar` is required.
class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  BaseAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.red[400],
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  print('Clicked home button');
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                color: Colors.black,
                icon: Icon(Icons.home),
              ),
            ],
          ),
        ]);
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(60);
}
