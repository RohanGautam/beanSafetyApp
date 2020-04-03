import 'package:flutter/material.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  BaseAppBar({this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.red[600],
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
