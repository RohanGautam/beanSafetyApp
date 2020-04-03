import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'Emergency Contacts'),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Text('Select contact of choice:',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25.0)),
              emContactButton("fire station", () => _launchCaller('tel:123')),
              emContactButton("police station", () => _launchCaller('tel:456')),
              emContactButton("Hospital", () => _launchCaller('tel:789')),
            ],
          ),
        ],
      ),
    );
  }

  Widget emContactButton(var text, var onPressed) {
    return Column(
      children: <Widget>[
        SizedBox(height: 40),
        SizedBox(
          width: 200.0,
          height: 70.0,
          child: FlatButton(
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red)),
            color: Colors.red,
            textColor: Colors.white,
            padding: EdgeInsets.all(8.0),
            onPressed: onPressed,
            child: Text(
              text.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _launchCaller(telUrl) async {
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      throw 'Could not launch $telUrl';
    }
  }
}
