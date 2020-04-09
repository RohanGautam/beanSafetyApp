import 'package:firebase_tutorial/shared/RoundIconButtonII.dart';
import 'package:firebase_tutorial/shared/baseAppBar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'EMERGENCY CONTACTS'),
      body: Stack(
        children: <Widget>[
          Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.width *
                  0.05, //TRY TO CHANGE THIS **0.30** value to achieve your goal
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/phone.png',
                        scale: 5.0,
                      ),
                      SizedBox(height: 18.0),
                      Text('Select an option to call the relevant authority',
                          style: TextStyle(fontSize: 15.0, color: Colors.grey))
                    ]),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 200.0, 10.0, 0.0),
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 3,
              children: <Widget>[
                RoundIconButtonII(
                  text: "FIRE STATION",
                  onPressed: () => _launchCaller('tel:123'),
                  icon: IconData(60220, fontFamily: 'MaterialIcons'),
                ),
                RoundIconButtonII(
                  text: "POLICE STATION",
                  onPressed: () => _launchCaller('tel:456'),
                  icon: IconData(59516, fontFamily: 'MaterialIcons'),
                ),
                RoundIconButtonII(
                  text: "HOSPITAL",
                  onPressed: () => _launchCaller('tel:789'),
                  icon: IconData(58696, fontFamily: 'MaterialIcons'),
                ),
              ],
            ),
          )
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
