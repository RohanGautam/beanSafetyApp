import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_tutorial/services/currentLocation.dart';
import 'package:provider/provider.dart';

class LocationTest extends StatefulWidget {
  @override
  _LocationTestState createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  String locationDisplay = '';

  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<QuerySnapshot>(context);
    print(userData.documents);
    for (var doc in userData.documents){
      print(doc.data);
    }

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
