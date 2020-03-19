import 'package:flutter/material.dart';
import 'package:firebase_tutorial/models/currentLocation.dart';

class LocationTest extends StatefulWidget {
  @override
  _LocationTestState createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  String locationDisplay = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Get location"),
              onPressed: () async {
                var location = await CurrentLocation().getCurrentLocation();
                if (location != null) {
                  setState(() {
                    locationDisplay =
                        "${location['latitude']}, ${location['longitude']}";
                  });
                } else {
                  setState(() {
                    locationDisplay = "unable to get location :(";
                  });
                }
              },
            ),
            Text(locationDisplay)
          ],
        ),
      ),
    );
  }
}
