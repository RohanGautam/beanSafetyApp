import 'package:flutter/material.dart';

/// A Custom red colored flat button 
class CustomButton extends StatelessWidget implements PreferredSizeWidget {
  String text;
  MaterialPageRoute mpr;

  CustomButton({this.text, this.mpr});
  
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.red)),
      color: Colors.red,
      textColor: Colors.white,
      padding: EdgeInsets.all(8.0),
      onPressed: () {
        Navigator.push(context, mpr);
      },
      child: Text(
        "$text".toUpperCase(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
