import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  String text;
  IconData icon;
  Function onPressed;
  MaterialPageRoute mpr;

  RoundIconButton(
      {@required this.text, @required this.icon, @required this.mpr});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          child: Icon(icon, color: Colors.white, size: 40.0,),
          onPressed: (){
            Navigator.push(context, mpr);
          },
          elevation: 0.0,
          shape: CircleBorder(),
          fillColor: Colors.red[400],
          padding: const EdgeInsets.all(25.0),
        ),
        SizedBox(height: 10.0,),
        Text(text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red[700],
          fontSize: 15.0,
        ))
      ],
    );
  }
}